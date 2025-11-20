import Foundation

public protocol FetchMovieDetailUseCase {
    func execute(idOrSlug: String) async throws -> Movie
}

public final class DefaultFetchMovieDetailUseCase: FetchMovieDetailUseCase {
    private let repo: MoviesRepository

    public init(repo: MoviesRepository) {
        self.repo = repo
    }

    public func execute(idOrSlug: String) async throws -> Movie {
        try await repo.fetchMovieDetail(idOrSlug: idOrSlug)
    }
}
