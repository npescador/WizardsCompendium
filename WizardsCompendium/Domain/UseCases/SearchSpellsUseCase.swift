import Foundation

public protocol SearchSpellsUseCase {
    func execute(query: String, page: Int) async throws -> [Spell]
}

public final class DefaultSearchSpellsUseCase: SearchSpellsUseCase {
    private let repo: SpellsRepository

    public init(repo: SpellsRepository) {
        self.repo = repo
    }

    public func execute(query: String, page: Int) async throws -> [Spell] {
        try await repo.searchSpells(query: query, page: page)
    }
}
