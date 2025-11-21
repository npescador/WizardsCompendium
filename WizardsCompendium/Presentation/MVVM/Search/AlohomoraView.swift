import SwiftUI

struct AlohomoraView: View {
    @State private var viewModel: AlohomoraViewModel
    @State private var favoriteCharacterIDs: Set<String>
    @State private var favoriteSpellIDs: Set<String>

    private let dependencies: AlohomoraDependencies

    init(viewModel: AlohomoraViewModel, dependencies: AlohomoraDependencies) {
        _viewModel = State(initialValue: viewModel)
        _favoriteCharacterIDs = State(initialValue: dependencies.favoritesStore.favorites(of: .character))
        _favoriteSpellIDs = State(initialValue: dependencies.favoritesStore.favorites(of: .spell))
        self.dependencies = dependencies
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            searchBar

            if viewModel.isLoading {
                ProgressView("Buscando...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 8) {
                    Text(error)
                        .foregroundStyle(.secondary)
                    Button("Reintentar") { viewModel.onSubmit() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else if isEmptyResults {
                Text(emptyMessage)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.characters.isEmpty {
                            charactersSection
                        }
                        if !viewModel.spells.isEmpty {
                            spellsSection
                        }
                        if !viewModel.movies.isEmpty {
                            moviesSection
                        }
                        if !viewModel.books.isEmpty {
                            booksSection
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding()
        .navigationTitle("Alohomora")
        .toolbarTitleDisplayMode(.large)
    }

    private var isEmptyResults: Bool {
        viewModel.characters.isEmpty &&
        viewModel.spells.isEmpty &&
        viewModel.movies.isEmpty &&
        viewModel.books.isEmpty
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "sparkle.magnifyingglass")
            TextField(
                "Busca en todo Hogwarts…",
                text: Binding(
                    get: { viewModel.query },
                    set: {
                        viewModel.clearIfEmpty($0)
                    }
                )
            )
            .onSubmit { viewModel.onSubmit() }
            .textInputAutocapitalization(.words)
            .disableAutocorrection(true)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var emptyMessage: String {
        viewModel.query.isEmpty
        ? "Usa el buscador para encontrar personajes, hechizos, películas y libros."
        : "No se han encontrado resultados."
    }

    private var charactersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Personajes")
                .font(.headline)
            ForEach(viewModel.characters) { character in
                NavigationLink {
                    CharacterDetailView(
                        character: character,
                        fetchDetail: DefaultFetchCharacterDetailUseCase(repo: dependencies.charactersRepo),
                        isFavorite: favoriteCharacterIDs.contains(character.id),
                        onToggleFavorite: { toggleCharacterFavorite(id: character.id) }
                    )
                } label: {
                    resultRow(
                        title: character.name,
                        subtitle: character.house
                    ) {
                        favoriteIcon(isOn: favoriteCharacterIDs.contains(character.id))
                    }
                }
            }
        }
    }

    private var spellsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hechizos")
                .font(.headline)
            ForEach(viewModel.spells) { spell in
                NavigationLink {
                    SpellDetailView(
                        spell: spell,
                        fetchDetail: DefaultFetchSpellDetailUseCase(repo: dependencies.spellsRepo),
                        isFavorite: favoriteSpellIDs.contains(spell.id),
                        onToggleFavorite: { toggleSpellFavorite(id: spell.id) }
                    )
                } label: {
                    resultRow(
                        title: spell.name,
                        subtitle: spell.incantation
                    ) {
                        favoriteIcon(isOn: favoriteSpellIDs.contains(spell.id))
                    }
                }
            }
        }
    }

    private var moviesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Películas")
                .font(.headline)
            ForEach(viewModel.movies) { movie in
                NavigationLink {
                    MovieDetailView(
                        movie: movie,
                        fetchDetail: DefaultFetchMovieDetailUseCase(repo: dependencies.moviesRepo)
                    )
                } label: {
                    resultRow(
                        title: movie.title,
                        subtitle: movie.releaseDate.map { $0.formatted(date: .abbreviated, time: .omitted) }
                    )
                }
            }
        }
    }

    private var booksSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Libros")
                .font(.headline)
            ForEach(viewModel.books) { book in
                NavigationLink {
                    BookDetailView(
                        book: book,
                        fetchDetail: DefaultFetchBookDetailUseCase(repo: dependencies.booksRepo)
                    )
                } label: {
                    resultRow(
                        title: book.title,
                        subtitle: book.releaseDate.map { $0.formatted(date: .abbreviated, time: .omitted) }
                    )
                }
            }
        }
    }

    private func resultRow<Accessory: View>(
        title: String,
        subtitle: String?,
        @ViewBuilder accessory: () -> Accessory
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            accessory()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func resultRow(title: String, subtitle: String?) -> some View {
        resultRow(title: title, subtitle: subtitle) {
            EmptyView()
        }
    }

    private func favoriteIcon(isOn: Bool) -> some View {
        Image(systemName: isOn ? "star.fill" : "star")
            .foregroundStyle(isOn ? .yellow : .secondary)
    }

    private func toggleCharacterFavorite(id: String) {
        dependencies.favoritesStore.toggleFavorite(id: id, type: .character)
        favoriteCharacterIDs = dependencies.favoritesStore.favorites(of: .character)
    }

    private func toggleSpellFavorite(id: String) {
        dependencies.favoritesStore.toggleFavorite(id: id, type: .spell)
        favoriteSpellIDs = dependencies.favoritesStore.favorites(of: .spell)
    }
}

struct AlohomoraDependencies {
    let charactersRepo: CharactersRepository
    let spellsRepo: SpellsRepository
    let moviesRepo: MoviesRepository
    let booksRepo: BooksRepository
    let favoritesStore: FavoritesStore
}
