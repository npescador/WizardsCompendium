import Foundation

public protocol SearchCharactersUseCase {
    func execute(query: String, page: Int, house: String?) async throws -> [Character]
}

public final class DefaultSearchCharactersUseCase: SearchCharactersUseCase {
    private let repo: CharactersRepository

    public init(repo: CharactersRepository) {
        self.repo = repo
    }

    public func execute(query: String, page: Int, house: String?) async throws -> [Character] {
        try await repo.searchCharacters(query: query, page: page, house: house)
    }
}
