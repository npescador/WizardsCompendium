import Foundation

public protocol FetchSpellDetailUseCase {
    func execute(idOrSlug: String) async throws -> Spell
}

public final class DefaultFetchSpellDetailUseCase: FetchSpellDetailUseCase {
    private let repo: SpellsRepository

    public init(repo: SpellsRepository) {
        self.repo = repo
    }

    public func execute(idOrSlug: String) async throws -> Spell {
        try await repo.fetchSpellDetail(idOrSlug: idOrSlug)
    }
}
