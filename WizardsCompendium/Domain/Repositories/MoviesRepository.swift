import Foundation

public protocol MoviesRepository {
    func fetchMovies(page: Int) async throws -> [Movie]
    func searchMovies(query: String, page: Int) async throws -> [Movie]
    func fetchMovieDetail(idOrSlug: String) async throws -> Movie
}
