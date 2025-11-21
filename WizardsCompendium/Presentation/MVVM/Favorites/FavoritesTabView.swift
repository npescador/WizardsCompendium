import SwiftUI

struct FavoritesTabView: View {
    @State private var viewModel: FavoritesTabViewModel
    @State private var coordinator: FavoritesCoordinator

    init(
        viewModel: FavoritesTabViewModel,
        coordinator: FavoritesCoordinator
    ) {
        _viewModel = State(initialValue: viewModel)
        _coordinator = State(initialValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if viewModel.isLoading && allEmpty {
                    ProgressView("Cargando favoritos...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel("Cargando favoritos")
                } else {
                    List {
                        if let error = viewModel.errorMessage {
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(error)
                                        .foregroundStyle(.secondary)
                                    Button("Reintentar") { viewModel.retry() }
                                        .buttonStyle(.borderedProminent)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Error cargando favoritos. \(error)")
                            }
                        }

                        if !viewModel.characters.isEmpty {
                            Section("Personajes") {
                                ForEach(viewModel.characters) { character in
                                    Button {
                                        coordinator.push(.character(character))
                                    } label: {
                                        CharacterRowView(
                                            character: character,
                                            isFavorite: true,
                                            onToggleFavorite: { viewModel.toggleFavorite(character.id, type: .character) }
                                        )
                                        .accessibilityLabel("Personaje \(character.name)")
                                    }
                                }
                            }
                        }

                        if !viewModel.spells.isEmpty {
                            Section("Hechizos") {
                                ForEach(viewModel.spells) { spell in
                                    Button {
                                        coordinator.push(.spell(spell))
                                    } label: {
                                        SpellRowView(
                                            spell: spell,
                                            isFavorite: true,
                                            onToggleFavorite: { viewModel.toggleFavorite(spell.id, type: .spell) }
                                        )
                                        .accessibilityLabel("Hechizo \(spell.name)")
                                    }
                                }
                            }
                        }

                        if !viewModel.movies.isEmpty {
                            Section("Películas") {
                                ForEach(viewModel.movies) { movie in
                                    Button {
                                        coordinator.push(.movie(movie))
                                    } label: {
                                        MovieRowView(movie: movie)
                                            .accessibilityLabel("Película \(movie.title)")
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
                                    Button {
                                        coordinator.push(.book(book))
                                    } label: {
                                        BookRowView(book: book)
                                            .accessibilityLabel("Libro \(book.title)")
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
                            VStack(spacing: 12) {
                                Image(systemName: "star")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                Text("Todavía no tienes favoritos")
                                    .foregroundStyle(.secondary)
                                Button("Actualizar favoritos") {
                                    viewModel.retry()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Lista de favoritos vacía")
                        }
                    }
                }
            }
        }
        .task {
            viewModel.onAppear()
        }
        .navigationTitle("Favoritos")
        .navigationDestination(for: FavoritesRoute.self) { route in
            coordinator.destination(for: route, toggle: viewModel.toggleFavorite)
        }
    }

    private var allEmpty: Bool {
        viewModel.characters.isEmpty &&
        viewModel.spells.isEmpty &&
        viewModel.movies.isEmpty &&
        viewModel.books.isEmpty
    }
}

struct MovieRowView: View {
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


enum FavoritesRoute: Hashable {
    case character(Character)
    case spell(Spell)
    case movie(Movie)
    case book(Book)
}

@MainActor
@Observable
final class FavoritesCoordinator {
    var path = NavigationPath()
    private let dependencies: FavoritesDetailDependencies

    init(dependencies: FavoritesDetailDependencies) {
        self.dependencies = dependencies
    }

    func push(_ route: FavoritesRoute) {
        path.append(route)
    }

    @ViewBuilder
    func destination(
        for route: FavoritesRoute,
        toggle: @escaping (String, FavoriteType) -> Void
    ) -> some View {
        switch route {
        case .character(let character):
            CharacterDetailView(
                character: character,
                fetchDetail: dependencies.fetchCharacterDetail,
                isFavorite: true,
                onToggleFavorite: { toggle(character.id, .character) }
            )
        case .spell(let spell):
            SpellDetailView(
                spell: spell,
                fetchDetail: dependencies.fetchSpellDetail,
                isFavorite: true,
                onToggleFavorite: { toggle(spell.id, .spell) }
            )
        case .movie(let movie):
            MovieDetailView(
                movie: movie,
                fetchDetail: dependencies.fetchMovieDetail
            )
        case .book(let book):
            BookDetailView(
                book: book,
                fetchDetail: dependencies.fetchBookDetail
            )
        }
    }
}

struct FavoritesDetailDependencies {
    let fetchCharacterDetail: FetchCharacterDetailUseCase
    let fetchSpellDetail: FetchSpellDetailUseCase
    let fetchMovieDetail: FetchMovieDetailUseCase
    let fetchBookDetail: FetchBookDetailUseCase
}
