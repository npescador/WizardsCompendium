import Foundation
import Observation

@MainActor
@Observable
final class SpellDetailViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(Spell)
        case failed(String)
    }

    var state: State = .idle

    private let spellID: String
    private let fetchDetail: FetchSpellDetailUseCase

    init(spellID: String, fetchDetail: FetchSpellDetailUseCase) {
        self.spellID = spellID
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
            let spell = try await fetchDetail.execute(idOrSlug: spellID)
            state = .loaded(spell)
        } catch {
            state = .failed("No se pudo cargar el hechizo.")
        }
    }
}
