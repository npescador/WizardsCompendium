import Foundation

public protocol FetchBooksUseCase {
    func execute(page: Int) async throws -> [Book]
}

public final class DefaultFetchBooksUseCase: FetchBooksUseCase {
    private let repo: BooksRepository

    public init(repo: BooksRepository) {
        self.repo = repo
    }

    public func execute(page: Int) async throws -> [Book] {
        try await repo.fetchBooks(page: page)
    }
}
