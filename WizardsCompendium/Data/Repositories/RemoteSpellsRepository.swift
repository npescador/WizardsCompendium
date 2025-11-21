import Foundation

public final class RemoteSpellsRepository: SpellsRepository {
    private let client: PotterDBClient

    public init(client: PotterDBClient) {
        self.client = client
    }

    public func fetchSpells(page: Int) async throws -> [Spell] {
        let response: JSONAPIListResponse<SpellAttributesDTO> = try await client.get(
            "spells",
            query: [URLQueryItem(name: "page[number]", value: "\(page)")]
        )
        return response.data.map(Self.map)
    }

    public func searchSpells(query: String, page: Int) async throws -> [Spell] {
        let response: JSONAPIListResponse<SpellAttributesDTO> = try await client.get(
            "spells",
            query: [
                URLQueryItem(name: "filter[name_cont]", value: query),
                URLQueryItem(name: "page[number]", value: "\(page)")
            ]
        )
        return response.data.map(Self.map)
    }

    public func fetchSpellDetail(idOrSlug: String) async throws -> Spell {
        let response: JSONAPIListResponse<SpellAttributesDTO> = try await client.get(
            "spells/\(idOrSlug)"
        )
        guard let item = response.data.first else {
            throw URLError(.badServerResponse)
        }
        return Self.map(item)
    }

    private static func map(_ item: JSONAPIListResponse<SpellAttributesDTO>.Item) -> Spell {
        let dto = item.attributes
        return Spell(
            id: item.id,
            name: dto.name,
            incantation: dto.incantation,
            effect: dto.effect,
            category: dto.category,
            light: dto.light,
            imageURL: dto.image.flatMap(URL.init(string:)),
            wikiURL: dto.wiki.flatMap(URL.init(string:))
        )
    }
}
