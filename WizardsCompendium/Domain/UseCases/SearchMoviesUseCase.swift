import Foundation

public protocol SearchMoviesUseCase {
    func execute(query: String, page: Int) async throws -> [Movie]
}

public final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    private let repo: MoviesRepository

    public init(repo: MoviesRepository) {
        self.repo = repo
    }

    public func execute(query: String, page: Int) async throws -> [Movie] {
        try await repo.searchMovies(query: query, page: page)
    }
}
