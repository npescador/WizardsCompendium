import SwiftUI

struct SpellsView: View {
    @State private var viewModel: SpellsViewModel

    private let repository: SpellsRepository

    init(viewModel: SpellsViewModel, repository: SpellsRepository) {
        _viewModel = State(initialValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        VStack {
            searchBar
            content
        }
        .navigationTitle("Hechizos")
        .toolbarTitleDisplayMode(.large)
        .task {
            viewModel.onAppear()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("Reintentar") { viewModel.retry() }
            Button("Cerrar", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "sparkles")
            TextField(
                "Busca un hechizo…",
                text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.onQueryChanged($0) }
                )
            )
            .textInputAutocapitalization(.words)
            .disableAutocorrection(true)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.spells.isEmpty && viewModel.isLoading {
            ProgressView("Cargando hechizos...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.spells) { spell in
                NavigationLink {
                    SpellDetailView(
                        spell: spell,
                        fetchDetail: DefaultFetchSpellDetailUseCase(repo: repository),
                        isFavorite: viewModel.favoriteIDs.contains(spell.id),
                        onToggleFavorite: { viewModel.toggleFavorite(id: spell.id) }
                    )
                } label: {
                    SpellRowView(
                        spell: spell,
                        isFavorite: viewModel.favoriteIDs.contains(spell.id),
                        onToggleFavorite: { viewModel.toggleFavorite(id: spell.id) }
                    )
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: spell)
                }
            }
            .listStyle(.plain)

            if viewModel.isLoading && !viewModel.spells.isEmpty {
                ProgressView()
                    .padding(.vertical, 8)
            }
        }
    }
}
