import Foundation

public protocol FetchMoviesUseCase {
    func execute(page: Int) async throws -> [Movie]
}

public final class DefaultFetchMoviesUseCase: FetchMoviesUseCase {
    private let repo: MoviesRepository

    public init(repo: MoviesRepository) {
        self.repo = repo
    }

    public func execute(page: Int) async throws -> [Movie] {
        try await repo.fetchMovies(page: page)
    }
}
