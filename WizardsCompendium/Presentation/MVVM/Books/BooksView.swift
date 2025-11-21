import SwiftUI

struct BooksView: View {
    @State private var viewModel: BooksViewModel
    let onSelect: (Book) -> Void

    init(viewModel: BooksViewModel, onSelect: @escaping (Book) -> Void) {
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
            Image(systemName: "book")
            TextField(
                "Busca un libro…",
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
        .accessibilityLabel("Barra de búsqueda de libros")
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.books.isEmpty {
            ProgressView("Cargando libros...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            VStack(spacing: 12) {
                Text(error)
                    .foregroundStyle(.secondary)
                Button("Reintentar") { viewModel.retry() }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.books.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "book")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("No hay libros para mostrar")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.books) { book in
                Button {
                    onSelect(book)
                } label: {
                    BookRowView(book: book)
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(current: book)
                }
            }
            .listStyle(.plain)

            if viewModel.isLoading && !viewModel.books.isEmpty {
                ProgressView()
                    .padding(.vertical, 8)
            }
        }
    }
}
