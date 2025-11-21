import Foundation

public protocol FetchCharacterDetailUseCase {
    func execute(idOrSlug: String) async throws -> Character
}

public final class DefaultFetchCharacterDetailUseCase: FetchCharacterDetailUseCase {
    private let repo: CharactersRepository

    public init(repo: CharactersRepository) {
        self.repo = repo
    }

    public func execute(idOrSlug: String) async throws -> Character {
        try await repo.fetchCharacterDetail(idOrSlug: idOrSlug)
    }
}
