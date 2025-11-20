import Foundation

public protocol CharactersRepository {
    func fetchCharacters(page: Int) async throws -> [Character]
    func searchCharacters(query: String, page: Int) async throws -> [Character]
    func fetchCharacterDetail(idOrSlug: String) async throws -> Character
}
