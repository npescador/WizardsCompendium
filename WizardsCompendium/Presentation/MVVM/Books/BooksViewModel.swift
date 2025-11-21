import Foundation
import Observation

@MainActor
@Observable
final class BooksViewModel {
    var books: [Book] = []
    var isLoading = false
    var errorMessage: String?
    var query: String = ""
    var page: Int = 1
    var canLoadMore: Bool = true

    private let fetchBooks: FetchBooksUseCase
    private let searchBooks: SearchBooksUseCase

    init(fetchBooks: FetchBooksUseCase, searchBooks: SearchBooksUseCase) {
        self.fetchBooks = fetchBooks
        self.searchBooks = searchBooks
    }

    func onAppear() {
        guard books.isEmpty else { return }
        Task { await loadInitial() }
    }

    func onQueryChanged(_ text: String) {
        query = text
        Task { await loadInitial() }
    }

    func loadMoreIfNeeded(current item: Book) {
        guard let last = books.last, last.id == item.id else { return }
        Task { await loadNextPage() }
    }

    func retry() {
        Task { await loadInitial() }
    }

    private func loadInitial() async {
        page = 1
        canLoadMore = true
        books.removeAll()
        await load()
    }

    private func loadNextPage() async {
        guard canLoadMore else { return }
        await load()
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let items = try await fetchPage(for: page)
            if items.isEmpty {
                canLoadMore = false
            } else {
                books.append(contentsOf: items)
                page += 1
            }
        } catch {
            errorMessage = "No se pudieron cargar los libros."
        }
    }

    private func fetchPage(for page: Int) async throws -> [Book] {
        if query.isEmpty {
            return try await fetchBooks.execute(page: page)
        } else {
            return try await searchBooks.execute(query: query, page: page)
        }
    }
}
