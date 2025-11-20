import Foundation

public protocol CharactersRepository {
    func fetchCharacters(page: Int, house: String?) async throws -> [Character]
    func searchCharacters(query: String, page: Int, house: String?) async throws -> [Character]
    func fetchCharacterDetail(idOrSlug: String) async throws -> Character
}
