import Foundation
import Observation

@MainActor
@Observable
final class FavoritesTabViewModel {
    var characters: [Character] = []
    var spells: [Spell] = []
    var movies: [Movie] = []
    var books: [Book] = []
    var isLoading = false
    var errorMessage: String?

    private let favoritesStore: FavoritesStore
    private let fetchCharacter: FetchCharacterDetailUseCase
    private let fetchSpell: FetchSpellDetailUseCase
    private let fetchMovie: FetchMovieDetailUseCase
    private let fetchBook: FetchBookDetailUseCase

    init(
        favoritesStore: FavoritesStore,
        fetchCharacter: FetchCharacterDetailUseCase,
        fetchSpell: FetchSpellDetailUseCase,
        fetchMovie: FetchMovieDetailUseCase,
        fetchBook: FetchBookDetailUseCase
    ) {
        self.favoritesStore = favoritesStore
        self.fetchCharacter = fetchCharacter
        self.fetchSpell = fetchSpell
        self.fetchMovie = fetchMovie
        self.fetchBook = fetchBook
    }

    func onAppear() {
        Task { await loadFavorites() }
    }

    func retry() {
        Task { await loadFavorites() }
    }

    func toggleFavorite(_ id: String, type: FavoriteType) {
        favoritesStore.toggleFavorite(id: id, type: type)
        removeLocal(id: id, type: type)
    }

    private func loadFavorites() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let characterIDs = favoritesStore.favorites(of: .character)
        let spellIDs = favoritesStore.favorites(of: .spell)
        let movieIDs = favoritesStore.favorites(of: .movie)
        let bookIDs = favoritesStore.favorites(of: .book)

        async let characters = fetchCharacters(ids: characterIDs)
        async let spells = fetchSpells(ids: spellIDs)
        async let movies = fetchMovies(ids: movieIDs)
        async let books = fetchBooks(ids: bookIDs)

        self.characters = await characters
        self.spells = await spells
        self.movies = await movies
        self.books = await books
    }

    private func fetchCharacters(ids: Set<String>) async -> [Character] {
        await fetchAll(ids: ids) { id in
            try await fetchCharacter.execute(idOrSlug: id)
        }
    }

    private func fetchSpells(ids: Set<String>) async -> [Spell] {
        await fetchAll(ids: ids) { id in
            try await fetchSpell.execute(idOrSlug: id)
        }
    }

    private func fetchMovies(ids: Set<String>) async -> [Movie] {
        await fetchAll(ids: ids) { id in
            try await fetchMovie.execute(idOrSlug: id)
        }
    }

    private func fetchBooks(ids: Set<String>) async -> [Book] {
        await fetchAll(ids: ids) { id in
            try await fetchBook.execute(idOrSlug: id)
        }
    }

    private func fetchAll<T>(
        ids: Set<String>,
        fetcher: @escaping (String) async throws -> T
    ) async -> [T] {
        guard !ids.isEmpty else { return [] }
        return await withTaskGroup(of: T?.self) { group in
            for id in ids {
                group.addTask {
                    try? await fetcher(id)
                }
            }
            var items: [T] = []
            for await item in group {
                if let value = item {
                    items.append(value)
                }
            }
            return items
        }
    }

    private func removeLocal(id: String, type: FavoriteType) {
        switch type {
        case .character:
            characters.removeAll { $0.id == id }
        case .spell:
            spells.removeAll { $0.id == id }
        case .movie:
            movies.removeAll { $0.id == id }
        case .book:
            books.removeAll { $0.id == id }
        }
    }
}
