import SwiftUI

struct MoviesView: View {
    @State private var viewModel: MoviesViewModel
    let onSelect: (Movie) -> Void

    init(viewModel: MoviesViewModel, onSelect: @escaping (Movie) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 12) {
            searchBar
            content
        }
        .padding(.horizontal)
        .task {
            viewModel.onAppear()
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "film")
            TextField(
                "Busca una película…",
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
        .accessibilityLabel("Barra de búsqueda de películas")
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            ProgressView("Cargando películas...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            VStack(spacing: 12) {
                Text(error)
                    .foregroundStyle(.secondary)
                Button("Reintentar") { viewModel.retry() }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.movies.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "film")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("No hay películas para mostrar")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.movies) { movie in
                Button {
                    onSelect(movie)
                } label: {
                    MovieRowView(movie: movie)
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: movie)
                }
            }
            .listStyle(.plain)

            if viewModel.isLoading && !viewModel.movies.isEmpty {
                ProgressView()
                    .padding(.vertical, 8)
            }
        }
    }
}
