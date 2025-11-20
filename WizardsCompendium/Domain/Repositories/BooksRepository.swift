import Foundation

public protocol BooksRepository {
    func fetchBooks(page: Int) async throws -> [Book]
    func searchBooks(query: String, page: Int) async throws -> [Book]
    func fetchBookDetail(idOrSlug: String) async throws -> Book
}
