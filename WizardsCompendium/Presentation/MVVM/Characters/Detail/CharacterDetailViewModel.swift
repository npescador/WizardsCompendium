import Foundation
import Observation

@MainActor
@Observable
final class CharacterDetailViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(Character)
        case failed(String)
    }

    var state: State = .idle

    private let characterID: String
    private let fetchDetail: FetchCharacterDetailUseCase

    init(characterID: String, fetchDetail: FetchCharacterDetailUseCase) {
        self.characterID = characterID
        self.fetchDetail = fetchDetail
    }

    func load() {
        guard case .idle = state else { return }
        state = .loading
        Task { await fetch() }
    }

    func retry() {
        state = .idle
        load()
    }

    private func fetch() async {
        do {
            let character = try await fetchDetail.execute(idOrSlug: characterID)
            state = .loaded(character)
        } catch {
            state = .failed("No se pudo cargar el personaje.")
        }
    }
}
