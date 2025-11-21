import Foundation

public protocol FetchCharactersUseCase {
    func execute(page: Int, house: String?) async throws -> [Character]
}

public final class DefaultFetchCharactersUseCase: FetchCharactersUseCase {
    private let repo: CharactersRepository

    public init(repo: CharactersRepository) {
        self.repo = repo
    }

    public func execute(page: Int, house: String?) async throws -> [Character] {
        try await repo.fetchCharacters(page: page, house: house)
    }
}
