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
    var lastFailedCount: Int = 0

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

        async let charactersResult = fetchCharacters(ids: characterIDs)
        async let spellsResult = fetchSpells(ids: spellIDs)
        async let moviesResult = fetchMovies(ids: movieIDs)
        async let booksResult = fetchBooks(ids: bookIDs)

        let allCharacters = await charactersResult
        let allSpells = await spellsResult
        let allMovies = await moviesResult
        let allBooks = await booksResult

        self.characters = allCharacters.items.sorted { $0.name < $1.name }
        self.spells = allSpells.items.sorted { $0.name < $1.name }
        self.movies = allMovies.items.sorted { $0.title < $1.title }
        self.books = allBooks.items.sorted { $0.title < $1.title }

        let failures = allCharacters.failures + allSpells.failures + allMovies.failures + allBooks.failures
        lastFailedCount = failures
        if failures > 0 {
            errorMessage = "No se pudieron cargar \(failures) favoritos."
        }
    }

    private func fetchCharacters(ids: Set<String>) async -> FavoritesResult<Character> {
        await fetchAll(ids: ids) { id in
            try await fetchCharacter.execute(idOrSlug: id)
        }
    }

    private func fetchSpells(ids: Set<String>) async -> FavoritesResult<Spell> {
        await fetchAll(ids: ids) { id in
            try await fetchSpell.execute(idOrSlug: id)
        }
    }

    private func fetchMovies(ids: Set<String>) async -> FavoritesResult<Movie> {
        await fetchAll(ids: ids) { id in
            try await fetchMovie.execute(idOrSlug: id)
        }
    }

    private func fetchBooks(ids: Set<String>) async -> FavoritesResult<Book> {
        await fetchAll(ids: ids) { id in
            try await fetchBook.execute(idOrSlug: id)
        }
    }

    private func fetchAll<T>(
        ids: Set<String>,
        fetcher: @escaping (String) async throws -> T
    ) async -> FavoritesResult<T> {
        guard !ids.isEmpty else { return .init(items: [], failures: 0) }
        var failures = 0

        let items: [T] = await withTaskGroup(of: T?.self) { group in
            for id in ids {
                group.addTask {
                    try? await fetcher(id)
                }
            }
            var items: [T] = []
            for await item in group {
                if let value = item {
                    items.append(value)
                } else {
                    failures += 1
                }
            }
            return items
        }

        return FavoritesResult(items: items, failures: failures)
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

struct FavoritesResult<T> {
    let items: [T]
    let failures: Int
}
