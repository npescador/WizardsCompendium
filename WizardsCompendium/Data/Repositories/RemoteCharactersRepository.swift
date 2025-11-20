import Foundation

public final class RemoteCharactersRepository: CharactersRepository {
    private let client: PotterDBClient

    public init(client: PotterDBClient) {
        self.client = client
    }

    public func fetchCharacters(page: Int) async throws -> [Character] {
        let response: JSONAPIListResponse<CharacterAttributesDTO> = try await client.get(
            "characters",
            query: [
                URLQueryItem(name: "page[number]", value: "\(page)")
            ]
        )
        return response.data.map(Self.map)
    }

    public func searchCharacters(query: String, page: Int) async throws -> [Character] {
        let response: JSONAPIListResponse<CharacterAttributesDTO> = try await client.get(
            "characters",
            query: [
                URLQueryItem(name: "filter[name_cont]", value: query),
                URLQueryItem(name: "page[number]", value: "\(page)")
            ]
        )
        return response.data.map(Self.map)
    }

    public func fetchCharacterDetail(idOrSlug: String) async throws -> Character {
        let response: JSONAPIListResponse<CharacterAttributesDTO> = try await client.get(
            "characters/\(idOrSlug)"
        )
        guard let item = response.data.first else {
            throw URLError(.badServerResponse)
        }
        return Self.map(item)
    }

    private static func map(_ item: JSONAPIListResponse<CharacterAttributesDTO>.Item) -> Character {
        let dto = item.attributes
        return Character(
            id: item.id,
            name: dto.name,
            house: dto.house,
            species: dto.species,
            patronus: dto.patronus,
            imageURL: dto.image.flatMap(URL.init(string:)),
            titles: dto.titles ?? [],
            jobs: dto.jobs ?? [],
            romances: dto.romances ?? [],
            wikiURL: dto.wiki.flatMap(URL.init(string:))
        )
    }
}
