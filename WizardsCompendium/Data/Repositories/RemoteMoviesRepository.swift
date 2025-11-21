import Foundation

public final class RemoteMoviesRepository: MoviesRepository {
    private let client: PotterDBClient

    public init(client: PotterDBClient) {
        self.client = client
    }

    public func fetchMovies(page: Int) async throws -> [Movie] {
        let response: JSONAPIListResponse<MovieAttributesDTO> = try await client.get(
            "movies",
            query: [URLQueryItem(name: "page[number]", value: "\(page)")]
        )
        return response.data.map(Self.map)
    }

    public func searchMovies(query: String, page: Int) async throws -> [Movie] {
        let response: JSONAPIListResponse<MovieAttributesDTO> = try await client.get(
            "movies",
            query: [
                URLQueryItem(name: "filter[title_cont]", value: query),
                URLQueryItem(name: "page[number]", value: "\(page)")
            ]
        )
        return response.data.map(Self.map)
    }

    public func fetchMovieDetail(idOrSlug: String) async throws -> Movie {
        let response: JSONAPIListResponse<MovieAttributesDTO> = try await client.get(
            "movies/\(idOrSlug)"
        )
        guard let item = response.data.first else {
            throw URLError(.badServerResponse)
        }
        return Self.map(item)
    }

    private static func map(_ item: JSONAPIListResponse<MovieAttributesDTO>.Item) -> Movie {
        let dto = item.attributes
        return Movie(
            id: item.id,
            title: dto.title,
            releaseDate: dto.releaseDate,
            summary: dto.summary,
            posterURL: dto.poster.flatMap(URL.init(string:)),
            wikiURL: dto.wiki.flatMap(URL.init(string:))
        )
    }
}
