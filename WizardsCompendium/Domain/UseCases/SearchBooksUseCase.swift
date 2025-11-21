import Foundation

public protocol SearchBooksUseCase {
    func execute(query: String, page: Int) async throws -> [Book]
}

public final class DefaultSearchBooksUseCase: SearchBooksUseCase {
    private let repo: BooksRepository

    public init(repo: BooksRepository) {
        self.repo = repo
    }

    public func execute(query: String, page: Int) async throws -> [Book] {
        try await repo.searchBooks(query: query, page: page)
    }
}
