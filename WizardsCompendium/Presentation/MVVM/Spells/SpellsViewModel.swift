import Foundation
import Observation

@MainActor
@Observable
final class SpellsViewModel {
    var spells: [Spell] = []
    var isLoading = false
    var errorMessage: String?
    var query: String = ""
    var page: Int = 1
    var canLoadMore: Bool = true
    var favoriteIDs: Set<String> = []

    private let fetchSpells: FetchSpellsUseCase
    private let searchSpells: SearchSpellsUseCase
    private let favoritesStore: FavoritesStore

    init(
        fetchSpells: FetchSpellsUseCase,
        searchSpells: SearchSpellsUseCase,
        favoritesStore: FavoritesStore
    ) {
        self.fetchSpells = fetchSpells
        self.searchSpells = searchSpells
        self.favoritesStore = favoritesStore
        self.favoriteIDs = favoritesStore.favorites(of: .spell)
    }

    func onAppear() {
        guard spells.isEmpty else { return }
        Task { await loadInitial() }
    }

    func onQueryChanged(_ text: String) {
        query = text
        Task { await loadInitial() }
    }

    func loadMoreIfNeeded(current item: Spell) {
        guard let last = spells.last, last.id == item.id else { return }
        Task { await loadNextPage() }
    }

    func toggleFavorite(id: String) {
        favoritesStore.toggleFavorite(id: id, type: .spell)
        favoriteIDs = favoritesStore.favorites(of: .spell)
    }

    func retry() {
        Task { await loadInitial() }
    }

    private func loadInitial() async {
        page = 1
        canLoadMore = true
        spells = []
        await load()
    }

    private func loadNextPage() async {
        guard canLoadMore else { return }
        await load()
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let items = try await fetchPage(for: page)
            if items.isEmpty {
                canLoadMore = false
            } else {
                spells.append(contentsOf: items)
                page += 1
            }
        } catch {
            errorMessage = "No se pudieron cargar los hechizos."
        }
    }

    private func fetchPage(for page: Int) async throws -> [Spell] {
        if query.isEmpty {
            return try await fetchSpells.execute(page: page)
        } else {
            return try await searchSpells.execute(query: query, page: page)
        }
    }
}
