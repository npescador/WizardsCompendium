import Foundation

public protocol FetchSpellsUseCase {
    func execute(page: Int) async throws -> [Spell]
}

public final class DefaultFetchSpellsUseCase: FetchSpellsUseCase {
    private let repo: SpellsRepository

    public init(repo: SpellsRepository) {
        self.repo = repo
    }

    public func execute(page: Int) async throws -> [Spell] {
        try await repo.fetchSpells(page: page)
    }
}
