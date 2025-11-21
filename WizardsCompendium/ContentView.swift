//
//  ContentView.swift
//  WizardsCompendium
//
//  Created by Ignacio Pescador Ruiz on 20/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var charactersViewModel: CharactersViewModel
    @State private var spellsViewModel: SpellsViewModel
    @State private var searchViewModel: AlohomoraViewModel
    @State private var favoritesViewModel: FavoritesTabViewModel
    @State private var favoritesCoordinator: FavoritesCoordinator
    @State private var libraryCoordinator: LibraryCoordinator
    @State private var moviesViewModel: MoviesViewModel
    @State private var booksViewModel: BooksViewModel

    private let charactersRepository: CharactersRepository
    private let spellsRepository: SpellsRepository
    private let moviesRepository: MoviesRepository
    private let booksRepository: BooksRepository
    private let favoritesStore: FavoritesStore

    init() {
        let client = PotterDBClient()
        let favorites = UserDefaultsFavoritesStore()

        let charactersRepository = RemoteCharactersRepository(client: client)
        let fetchCharacters = DefaultFetchCharactersUseCase(repo: charactersRepository)
        let searchCharacters = DefaultSearchCharactersUseCase(repo: charactersRepository)
        let charactersVM = CharactersViewModel(
            fetchCharacters: fetchCharacters,
            searchCharacters: searchCharacters,
            favoritesStore: favorites
        )
        _charactersViewModel = State(initialValue: charactersVM)

        let spellsRepository = RemoteSpellsRepository(client: client)
        let fetchSpells = DefaultFetchSpellsUseCase(repo: spellsRepository)
        let searchSpells = DefaultSearchSpellsUseCase(repo: spellsRepository)
        let spellsVM = SpellsViewModel(
            fetchSpells: fetchSpells,
            searchSpells: searchSpells,
            favoritesStore: favorites
        )
        _spellsViewModel = State(initialValue: spellsVM)

        let moviesRepository = RemoteMoviesRepository(client: client)
        let searchMovies = DefaultSearchMoviesUseCase(repo: moviesRepository)
        let moviesVM = MoviesViewModel(
            fetchMovies: DefaultFetchMoviesUseCase(repo: moviesRepository),
            searchMovies: searchMovies
        )

        let booksRepository = RemoteBooksRepository(client: client)
        let searchBooks = DefaultSearchBooksUseCase(repo: booksRepository)
        let booksVM = BooksViewModel(
            fetchBooks: DefaultFetchBooksUseCase(repo: booksRepository),
            searchBooks: searchBooks
        )
        _searchViewModel = State(initialValue: AlohomoraViewModel(
            characters: searchCharacters,
            spells: searchSpells,
            movies: searchMovies,
            books: searchBooks
        ))

        _moviesViewModel = State(initialValue: moviesVM)
        _booksViewModel = State(initialValue: booksVM)
        _favoritesViewModel = State(initialValue: FavoritesTabViewModel(
            favoritesStore: favorites,
            fetchCharacter: DefaultFetchCharacterDetailUseCase(repo: charactersRepository),
            fetchSpell: DefaultFetchSpellDetailUseCase(repo: spellsRepository),
            fetchMovie: DefaultFetchMovieDetailUseCase(repo: moviesRepository),
            fetchBook: DefaultFetchBookDetailUseCase(repo: booksRepository),
            cachedCharacters: { charactersVM.characters },
            cachedSpells: { spellsVM.spells },
            cachedMovies: { moviesVM.movies },
            cachedBooks: { booksVM.books }
        ))
        _favoritesCoordinator = State(initialValue: FavoritesCoordinator(
            dependencies: FavoritesDetailDependencies(
                fetchCharacterDetail: DefaultFetchCharacterDetailUseCase(repo: charactersRepository),
                fetchSpellDetail: DefaultFetchSpellDetailUseCase(repo: spellsRepository),
                fetchMovieDetail: DefaultFetchMovieDetailUseCase(repo: moviesRepository),
                fetchBookDetail: DefaultFetchBookDetailUseCase(repo: booksRepository)
            )
        ))
        _libraryCoordinator = State(initialValue: LibraryCoordinator(
            dependencies: LibraryDetailDependencies(
                fetchMovieDetail: DefaultFetchMovieDetailUseCase(repo: moviesRepository),
                fetchBookDetail: DefaultFetchBookDetailUseCase(repo: booksRepository)
            )
        ))

        self.charactersRepository = charactersRepository
        self.spellsRepository = spellsRepository
        self.moviesRepository = moviesRepository
        self.booksRepository = booksRepository
        self.favoritesStore = favorites
    }

    var body: some View {
        TabView {
            NavigationStack {
                CharactersView(viewModel: charactersViewModel, repository: charactersRepository)
            }
            .tabItem {
                Label("Personajes", systemImage: "person.3.fill")
            }

            NavigationStack {
                SpellsView(viewModel: spellsViewModel, repository: spellsRepository)
            }
            .tabItem {
                Label("Hechizos", systemImage: "wand.and.stars")
            }

            FavoritesTabView(
                viewModel: favoritesViewModel,
                coordinator: favoritesCoordinator
            )
            .tabItem {
                Label("Favoritos", systemImage: "star.fill")
            }

            NavigationStack {
                AlohomoraView(
                    viewModel: searchViewModel,
                    dependencies: AlohomoraDependencies(
                        charactersRepo: charactersRepository,
                        spellsRepo: spellsRepository,
                        moviesRepo: moviesRepository,
                        booksRepo: booksRepository,
                        favoritesStore: favoritesStore
                    )
                )
            }
            .tabItem {
                Label("Alohomora", systemImage: "sparkle.magnifyingglass")
            }

            LibraryView(
                coordinator: libraryCoordinator,
                moviesViewModel: moviesViewModel,
                booksViewModel: booksViewModel
            )
            .tabItem {
                Label("Biblioteca", systemImage: "books.vertical")
            }
        }
    }
}

#if DEBUG
#Preview {
    let favoritesStore = PreviewFavoritesStore(
        characterIDs: ["1"],
        spellIDs: ["sp1"],
        movieIDs: ["m1"],
        bookIDs: ["b1"]
    )

    TabView {
        NavigationStack {
            CharactersView(
                viewModel: CharactersViewModel(
                    fetchCharacters: PreviewCharactersRepository(),
                    searchCharacters: PreviewCharactersRepository(),
                    favoritesStore: favoritesStore
                ),
                repository: PreviewCharactersRepository()
            )
        }
        .tabItem { Label("Personajes", systemImage: "person.3.fill") }

        NavigationStack {
            SpellsView(
                viewModel: SpellsViewModel(
                    fetchSpells: PreviewSpellsRepository(),
                    searchSpells: PreviewSpellsRepository(),
                    favoritesStore: favoritesStore
                ),
                repository: PreviewSpellsRepository()
            )
        }
        .tabItem { Label("Hechizos", systemImage: "wand.and.stars") }

        FavoritesTabView(
            viewModel: FavoritesTabViewModel(
                favoritesStore: favoritesStore,
                fetchCharacter: PreviewCharactersRepository(),
                fetchSpell: PreviewSpellsRepository(),
                fetchMovie: PreviewMoviesRepository(),
                fetchBook: PreviewBooksRepository(),
                cachedCharacters: { PreviewCharactersRepository.sample },
                cachedSpells: { PreviewSpellsRepository.sample },
                cachedMovies: { PreviewMoviesRepository.sample },
                cachedBooks: { PreviewBooksRepository.sample }
            ),
            coordinator: FavoritesCoordinator(
                dependencies: FavoritesDetailDependencies(
                    fetchCharacterDetail: PreviewCharactersRepository(),
                    fetchSpellDetail: PreviewSpellsRepository(),
                    fetchMovieDetail: PreviewMoviesRepository(),
                    fetchBookDetail: PreviewBooksRepository()
                )
            )
        )
        .tabItem { Label("Favoritos", systemImage: "star.fill") }

        NavigationStack {
            AlohomoraView(
                viewModel: AlohomoraViewModel(
                    characters: PreviewCharactersRepository(),
                    spells: PreviewSpellsRepository(),
                    movies: PreviewMoviesRepository(),
                    books: PreviewBooksRepository()
                ),
                dependencies: AlohomoraDependencies(
                    charactersRepo: PreviewCharactersRepository(),
                    spellsRepo: PreviewSpellsRepository(),
                    moviesRepo: PreviewMoviesRepository(),
                    booksRepo: PreviewBooksRepository(),
                    favoritesStore: favoritesStore
                )
            )
        }
        .tabItem { Label("Alohomora", systemImage: "sparkle.magnifyingglass") }

        LibraryView(
            coordinator: LibraryCoordinator(
                dependencies: LibraryDetailDependencies(
                    fetchMovieDetail: PreviewMoviesRepository(),
                    fetchBookDetail: PreviewBooksRepository()
                )
            ),
            moviesViewModel: MoviesViewModel(
                fetchMovies: PreviewMoviesRepository(),
                searchMovies: PreviewMoviesRepository()
            ),
            booksViewModel: BooksViewModel(
                fetchBooks: PreviewBooksRepository(),
                searchBooks: PreviewBooksRepository()
            )
        )
        .tabItem { Label("Biblioteca", systemImage: "books.vertical") }
    }
}

private final class PreviewCharactersRepository: CharactersRepository, FetchCharactersUseCase, SearchCharactersUseCase, FetchCharacterDetailUseCase {
    func execute(page: Int, house: String?) async throws -> [Character] { try await fetchCharacters(page: page, house: house) }
    func execute(query: String, page: Int, house: String?) async throws -> [Character] { try await searchCharacters(query: query, page: page, house: house) }
    func execute(idOrSlug: String) async throws -> Character { try await fetchCharacterDetail(idOrSlug: idOrSlug) }

    func fetchCharacters(page: Int, house: String?) async throws -> [Character] { Self.sample }
    func searchCharacters(query: String, page: Int, house: String?) async throws -> [Character] { Self.sample.filter { $0.name.lowercased().contains(query.lowercased()) } }
    func fetchCharacterDetail(idOrSlug: String) async throws -> Character { Self.sample[0] }

    static let sample: [Character] = [
        Character(
            id: "1",
            name: "Harry Potter",
            house: "Gryffindor",
            species: "Human",
            patronus: "Stag",
            imageURL: nil,
            titles: ["The Boy Who Lived"],
            jobs: ["Auror"],
            romances: ["Ginny Weasley"],
            wikiURL: nil
        ),
        Character(
            id: "2",
            name: "Hermione Granger",
            house: "Gryffindor",
            species: "Human",
            patronus: "Otter",
            imageURL: nil,
            titles: [],
            jobs: ["Minister for Magic"],
            romances: ["Ron Weasley"],
            wikiURL: nil
        )
    ]
}

private final class PreviewSpellsRepository: SpellsRepository, FetchSpellsUseCase, SearchSpellsUseCase, FetchSpellDetailUseCase {
    func execute(page: Int) async throws -> [Spell] { try await fetchSpells(page: page) }
    func execute(query: String, page: Int) async throws -> [Spell] { try await searchSpells(query: query, page: page) }
    func execute(idOrSlug: String) async throws -> Spell { try await fetchSpellDetail(idOrSlug: idOrSlug) }

    func fetchSpells(page: Int) async throws -> [Spell] { Self.sample }
    func searchSpells(query: String, page: Int) async throws -> [Spell] {
        Self.sample.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    func fetchSpellDetail(idOrSlug: String) async throws -> Spell { Self.sample[0] }

    static let sample: [Spell] = [
        Spell(
            id: "sp1",
            name: "Expelliarmus",
            incantation: "Expelliarmus",
            effect: "Desarma al oponente",
            category: "Charm",
            light: "Rojo",
            imageURL: nil,
            wikiURL: nil
        ),
        Spell(
            id: "sp2",
            name: "Lumos",
            incantation: "Lumos",
            effect: "Ilumina la varita",
            category: "Charm",
            light: "Blanco",
            imageURL: nil,
            wikiURL: nil
        )
    ]
}

private final class PreviewMoviesRepository: MoviesRepository, FetchMoviesUseCase, SearchMoviesUseCase, FetchMovieDetailUseCase {
    func execute(page: Int) async throws -> [Movie] { try await fetchMovies(page: page) }
    func execute(query: String, page: Int) async throws -> [Movie] { try await searchMovies(query: query, page: page) }
    func execute(idOrSlug: String) async throws -> Movie { try await fetchMovieDetail(idOrSlug: idOrSlug) }

    func fetchMovies(page: Int) async throws -> [Movie] { Self.sample }
    func searchMovies(query: String, page: Int) async throws -> [Movie] { Self.sample }
    func fetchMovieDetail(idOrSlug: String) async throws -> Movie { Self.sample[0] }

    static let sample: [Movie] = [
        Movie(
            id: "m1",
            title: "Harry Potter and the Philosopher's Stone",
            releaseDate: nil,
            summary: nil,
            posterURL: nil,
            wikiURL: nil
        )
    ]
}

private final class PreviewBooksRepository: BooksRepository, FetchBooksUseCase, SearchBooksUseCase, FetchBookDetailUseCase {
    func execute(page: Int) async throws -> [Book] { try await fetchBooks(page: page) }
    func execute(query: String, page: Int) async throws -> [Book] { try await searchBooks(query: query, page: page) }
    func execute(idOrSlug: String) async throws -> Book { try await fetchBookDetail(idOrSlug: idOrSlug) }

    func fetchBooks(page: Int) async throws -> [Book] { Self.sample }
    func searchBooks(query: String, page: Int) async throws -> [Book] { Self.sample }
    func fetchBookDetail(idOrSlug: String) async throws -> Book { Self.sample[0] }

    static let sample: [Book] = [
        Book(
            id: "b1",
            title: "Harry Potter and the Chamber of Secrets",
            releaseDate: nil,
            summary: nil,
            coverURL: nil,
            wikiURL: nil
        )
    ]
}

private final class PreviewFavoritesStore: FavoritesStore {
    private var characterIDs: Set<String>
    private var spellIDs: Set<String>
    private var movieIDs: Set<String>
    private var bookIDs: Set<String>

    init(
        characterIDs: Set<String> = [],
        spellIDs: Set<String> = [],
        movieIDs: Set<String> = [],
        bookIDs: Set<String> = []
    ) {
        self.characterIDs = characterIDs
        self.spellIDs = spellIDs
        self.movieIDs = movieIDs
        self.bookIDs = bookIDs
    }

    func toggleFavorite(id: String, type: FavoriteType) {
        switch type {
        case .character: toggle(&characterIDs, id: id)
        case .spell: toggle(&spellIDs, id: id)
        case .movie: toggle(&movieIDs, id: id)
        case .book: toggle(&bookIDs, id: id)
        }
    }

    func isFavorite(id: String, type: FavoriteType) -> Bool {
        favorites(of: type).contains(id)
    }

    func favorites(of type: FavoriteType) -> Set<String> {
        switch type {
        case .character: return characterIDs
        case .spell: return spellIDs
        case .movie: return movieIDs
        case .book: return bookIDs
        }
    }

    private func toggle(_ set: inout Set<String>, id: String) {
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
    }
}
#endif
