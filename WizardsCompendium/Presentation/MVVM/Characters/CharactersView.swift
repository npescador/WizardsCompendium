import SwiftUI

struct CharactersView: View {
    @State private var viewModel: CharactersViewModel

    init(viewModel: CharactersViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                content
            }
            .navigationTitle("Personajes")
            .toolbarTitleDisplayMode(.large)
        }
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
            Image(systemName: "wand.and.stars")
            TextField(
                "Busca un mago o bruja…",
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

    private var content: some View {
        Group {
            if viewModel.characters.isEmpty && viewModel.isLoading {
                ProgressView("Cargando personajes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.characters) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        CharacterRowView(character: character)
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(current: character)
                    }
                }
                .listStyle(.plain)

                if viewModel.isLoading && !viewModel.characters.isEmpty {
                    ProgressView()
                        .padding(.vertical, 8)
                }
            }
        }
    }
}
