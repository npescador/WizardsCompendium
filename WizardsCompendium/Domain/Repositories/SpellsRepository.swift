import Foundation

public protocol SpellsRepository {
    func fetchSpells(page: Int) async throws -> [Spell]
    func searchSpells(query: String, page: Int) async throws -> [Spell]
    func fetchSpellDetail(idOrSlug: String) async throws -> Spell
}
