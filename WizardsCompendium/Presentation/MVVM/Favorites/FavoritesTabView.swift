import SwiftUI

struct FavoritesTabView: View {
    @State private var viewModel: FavoritesTabViewModel

    private let charactersRepo: CharactersRepository
    private let spellsRepo: SpellsRepository
    private let moviesRepo: MoviesRepository
    private let booksRepo: BooksRepository

    init(
        viewModel: FavoritesTabViewModel,
        charactersRepo: CharactersRepository,
        spellsRepo: SpellsRepository,
        moviesRepo: MoviesRepository,
        booksRepo: BooksRepository
    ) {
        _viewModel = State(initialValue: viewModel)
        self.charactersRepo = charactersRepo
        self.spellsRepo = spellsRepo
        self.moviesRepo = moviesRepo
        self.booksRepo = booksRepo
    }

    var body: some View {
        Group {
            if viewModel.isLoading && allEmpty {
                ProgressView("Cargando favoritos...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    if !viewModel.characters.isEmpty {
                        Section("Personajes") {
                            ForEach(viewModel.characters) { character in
                                NavigationLink {
                                    CharacterDetailView(
                                        character: character,
                                        fetchDetail: DefaultFetchCharacterDetailUseCase(repo: charactersRepo),
                                        isFavorite: true,
                                        onToggleFavorite: { viewModel.toggleFavorite(character.id, type: .character) }
                                    )
                                } label: {
                                    CharacterRowView(
                                        character: character,
                                        isFavorite: true,
                                        onToggleFavorite: { viewModel.toggleFavorite(character.id, type: .character) }
                                    )
                                }
                            }
                        }
                    }

                    if !viewModel.spells.isEmpty {
                        Section("Hechizos") {
                            ForEach(viewModel.spells) { spell in
                                NavigationLink {
                                    SpellDetailView(
                                        spell: spell,
                                        fetchDetail: DefaultFetchSpellDetailUseCase(repo: spellsRepo),
                                        isFavorite: true,
                                        onToggleFavorite: { viewModel.toggleFavorite(spell.id, type: .spell) }
                                    )
                                } label: {
                                    SpellRowView(
                                        spell: spell,
                                        isFavorite: true,
                                        onToggleFavorite: { viewModel.toggleFavorite(spell.id, type: .spell) }
                                    )
                                }
                            }
                        }
                    }

                    if !viewModel.movies.isEmpty {
                        Section("Películas") {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink {
                                    MovieDetailView(
                                        movie: movie,
                                        fetchDetail: DefaultFetchMovieDetailUseCase(repo: moviesRepo)
                                    )
                                } label: {
                                    MovieRowView(movie: movie)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.toggleFavorite(movie.id, type: .movie)
                                    } label: {
                                        Label("Quitar", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.books.isEmpty {
                        Section("Libros") {
                            ForEach(viewModel.books) { book in
                                NavigationLink {
                                    BookDetailView(
                                        book: book,
                                        fetchDetail: DefaultFetchBookDetailUseCase(repo: booksRepo)
                                    )
                                } label: {
                                    BookRowView(book: book)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.toggleFavorite(book.id, type: .book)
                                    } label: {
                                        Label("Quitar", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .overlay {
                    if allEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "star")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("Todavía no tienes favoritos")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .task {
            viewModel.onAppear()
        }
        .navigationTitle("Favoritos")
    }

    private var allEmpty: Bool {
        viewModel.characters.isEmpty &&
        viewModel.spells.isEmpty &&
        viewModel.movies.isEmpty &&
        viewModel.books.isEmpty
    }
}

private struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                if let release = movie.releaseDate {
                    Text(release.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

private struct BookRowView: View {
    let book: Book

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                if let release = book.releaseDate {
                    Text(release.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}
