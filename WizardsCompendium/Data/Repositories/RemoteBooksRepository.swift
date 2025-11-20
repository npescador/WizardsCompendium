import Foundation

public final class RemoteBooksRepository: BooksRepository {
    private let client: PotterDBClient

    public init(client: PotterDBClient) {
        self.client = client
    }

    public func fetchBooks(page: Int) async throws -> [Book] {
        let response: JSONAPIListResponse<BookAttributesDTO> = try await client.get(
            "books",
            query: [URLQueryItem(name: "page[number]", value: "\(page)")]
        )
        return response.data.map(Self.map)
    }

    public func searchBooks(query: String, page: Int) async throws -> [Book] {
        let response: JSONAPIListResponse<BookAttributesDTO> = try await client.get(
            "books",
            query: [
                URLQueryItem(name: "filter[title_cont]", value: query),
                URLQueryItem(name: "page[number]", value: "\(page)")
            ]
        )
        return response.data.map(Self.map)
    }

    public func fetchBookDetail(idOrSlug: String) async throws -> Book {
        let response: JSONAPIListResponse<BookAttributesDTO> = try await client.get(
            "books/\(idOrSlug)"
        )
        guard let item = response.data.first else {
            throw URLError(.badServerResponse)
        }
        return Self.map(item)
    }

    private static func map(_ item: JSONAPIListResponse<BookAttributesDTO>.Item) -> Book {
        let dto = item.attributes
        return Book(
            id: item.id,
            title: dto.title,
            releaseDate: dto.releaseDate,
            summary: dto.summary,
            coverURL: dto.cover.flatMap(URL.init(string:)),
            wikiURL: dto.wiki.flatMap(URL.init(string:))
        )
    }
}
