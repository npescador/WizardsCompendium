import Foundation

public protocol FetchBookDetailUseCase {
    func execute(idOrSlug: String) async throws -> Book
}

public final class DefaultFetchBookDetailUseCase: FetchBookDetailUseCase {
    private let repo: BooksRepository

    public init(repo: BooksRepository) {
        self.repo = repo
    }

    public func execute(idOrSlug: String) async throws -> Book {
        try await repo.fetchBookDetail(idOrSlug: idOrSlug)
    }
}
