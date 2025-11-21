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
    private let cachedCharacters: () -> [Character]
    private let cachedSpells: () -> [Spell]
    private let cachedMovies: () -> [Movie]
    private let cachedBooks: () -> [Book]

    init(
        favoritesStore: FavoritesStore,
        fetchCharacter: FetchCharacterDetailUseCase,
        fetchSpell: FetchSpellDetailUseCase,
        fetchMovie: FetchMovieDetailUseCase,
        fetchBook: FetchBookDetailUseCase,
        cachedCharacters: @escaping () -> [Character],
        cachedSpells: @escaping () -> [Spell],
        cachedMovies: @escaping () -> [Movie],
        cachedBooks: @escaping () -> [Book]
    ) {
        self.favoritesStore = favoritesStore
        self.fetchCharacter = fetchCharacter
        self.fetchSpell = fetchSpell
        self.fetchMovie = fetchMovie
        self.fetchBook = fetchBook
        self.cachedCharacters = cachedCharacters
        self.cachedSpells = cachedSpells
        self.cachedMovies = cachedMovies
        self.cachedBooks = cachedBooks
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

        let cachedCharacters = cachedCharacters().filter { characterIDs.contains($0.id) }
        let cachedCharacterIDs = Set(cachedCharacters.map(\.id))
        let characterIDsToFetch = characterIDs.subtracting(cachedCharacterIDs)

        let cachedSpells = cachedSpells().filter { spellIDs.contains($0.id) }
        let cachedSpellIDs = Set(cachedSpells.map(\.id))
        let spellIDsToFetch = spellIDs.subtracting(cachedSpellIDs)

        let cachedMovies = cachedMovies().filter { movieIDs.contains($0.id) }
        let cachedMovieIDs = Set(cachedMovies.map(\.id))
        let movieIDsToFetch = movieIDs.subtracting(cachedMovieIDs)

        let cachedBooks = cachedBooks().filter { bookIDs.contains($0.id) }
        let cachedBookIDs = Set(cachedBooks.map(\.id))
        let bookIDsToFetch = bookIDs.subtracting(cachedBookIDs)

        async let charactersResult = fetchCharacters(ids: characterIDsToFetch)
        async let spellsResult = fetchSpells(ids: spellIDsToFetch)
        async let moviesResult = fetchMovies(ids: movieIDsToFetch)
        async let booksResult = fetchBooks(ids: bookIDsToFetch)

        let allCharacters = await charactersResult
        let allSpells = await spellsResult
        let allMovies = await moviesResult
        let allBooks = await booksResult

        self.characters = (cachedCharacters + allCharacters.items)
            .reduce(into: [String: Character]()) { dict, item in dict[item.id] = item }
            .values.sorted { $0.name < $1.name }
        self.spells = (cachedSpells + allSpells.items)
            .reduce(into: [String: Spell]()) { dict, item in dict[item.id] = item }
            .values.sorted { $0.name < $1.name }
        self.movies = (cachedMovies + allMovies.items)
            .reduce(into: [String: Movie]()) { dict, item in dict[item.id] = item }
            .values.sorted { $0.title < $1.title }
        self.books = (cachedBooks + allBooks.items)
            .reduce(into: [String: Book]()) { dict, item in dict[item.id] = item }
            .values.sorted { $0.title < $1.title }

        let failures = allCharacters.failures + allSpells.failures + allMovies.failures + allBooks.failures
        let successes = characters.count + spells.count + movies.count + books.count
        let total = characterIDs.count + spellIDs.count + movieIDs.count + bookIDs.count

        lastFailedCount = failures
        if failures == total && total > 0 {
            errorMessage = "No se pudieron cargar tus favoritos. Reintenta."
        } else {
            errorMessage = nil
        }
    }

    private func fetchCharacters(ids: Set<String>) async -> FavoritesResult<Character> {
        await fetchAll(ids: ids) { id in
            try await self.fetchCharacter.execute(idOrSlug: id)
        }
    }

    private func fetchSpells(ids: Set<String>) async -> FavoritesResult<Spell> {
        await fetchAll(ids: ids) { id in
            try await self.fetchSpell.execute(idOrSlug: id)
        }
    }

    private func fetchMovies(ids: Set<String>) async -> FavoritesResult<Movie> {
        await fetchAll(ids: ids) { id in
            try await self.fetchMovie.execute(idOrSlug: id)
        }
    }

    private func fetchBooks(ids: Set<String>) async -> FavoritesResult<Book> {
        await fetchAll(ids: ids) { id in
            try await self.fetchBook.execute(idOrSlug: id)
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
