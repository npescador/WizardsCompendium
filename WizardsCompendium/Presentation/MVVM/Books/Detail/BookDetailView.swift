import SwiftUI

struct BookDetailView: View {
    let initialBook: Book
    @State private var viewModel: BookDetailViewModel

    init(book: Book, fetchDetail: FetchBookDetailUseCase) {
        self.initialBook = book
        _viewModel = State(initialValue: BookDetailViewModel(bookID: book.id, fetchDetail: fetchDetail))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                content
            }
            .padding()
        }
        .navigationTitle(displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.load()
        }
    }

    private var displayTitle: String {
        switch viewModel.state {
        case .loaded(let book):
            return book.title
        default:
            return initialBook.title
        }
    }

    private var header: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.purple.opacity(0.2))
                .frame(height: 180)
            Image(systemName: "book")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Cargando detalle...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            VStack(spacing: 12) {
                Text(message)
                    .foregroundStyle(.secondary)
                Button("Reintentar") { viewModel.retry() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let book):
            infoSection(book)
        }
    }

    private func infoSection(_ book: Book) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let date = book.releaseDate {
                labeled("Publicación", value: date.formatted(date: .abbreviated, time: .omitted))
            }
            if let summary = book.summary {
                labeled("Sinopsis", value: summary)
            }
            if let wiki = book.wikiURL {
                Link("Ver en Wiki", destination: wiki)
                    .font(.headline)
                    .padding(.top, 6)
            }
        }
    }

    private func labeled(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}
