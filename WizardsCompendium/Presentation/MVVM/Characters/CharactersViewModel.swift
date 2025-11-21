import Foundation
import Observation

@MainActor
@Observable
final class CharactersViewModel {
    var characters: [Character] = []
    var isLoading = false
    var errorMessage: String?
    var query: String = ""
    var page: Int = 1
    var canLoadMore: Bool = true
    var selectedHouse: String?
    var favoriteIDs: Set<String> = []

    private let fetchCharacters: FetchCharactersUseCase
    private let searchCharacters: SearchCharactersUseCase
    private let favoritesStore: FavoritesStore

    init(
        fetchCharacters: FetchCharactersUseCase,
        searchCharacters: SearchCharactersUseCase,
        favoritesStore: FavoritesStore
    ) {
        self.fetchCharacters = fetchCharacters
        self.searchCharacters = searchCharacters
        self.favoritesStore = favoritesStore
        self.favoriteIDs = favoritesStore.favorites(of: .character)
    }

    func onAppear() {
        guard characters.isEmpty else { return }
        Task { await loadInitial() }
    }

    func onQueryChanged(_ text: String) {
        query = text
        Task { await loadInitial() }
    }

    func onHouseChanged(_ house: String?) {
        selectedHouse = house
        Task { await loadInitial() }
    }

    func loadMoreIfNeeded(current item: Character) {
        guard let last = characters.last, last.id == item.id else { return }
        Task { await loadNextPage() }
    }

    func toggleFavorite(id: String) {
        favoritesStore.toggleFavorite(id: id, type: .character)
        favoriteIDs = favoritesStore.favorites(of: .character)
    }

    func retry() {
        Task { await loadInitial() }
    }

    private func loadInitial() async {
        page = 1
        canLoadMore = true
        characters = []
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
                characters.append(contentsOf: items)
                page += 1
            }
        } catch {
            errorMessage = "No se pudieron cargar los personajes."
        }
    }

    private func fetchPage(for page: Int) async throws -> [Character] {
        if query.isEmpty {
            return try await fetchCharactersPage(page)
        } else {
            return try await searchCharactersPage(page, query: query)
        }
    }

    private func fetchCharactersPage(_ page: Int) async throws -> [Character] {
        try await fetchCharacters.execute(page: page, house: selectedHouse)
    }

    private func searchCharactersPage(_ page: Int, query: String) async throws -> [Character] {
        try await searchCharacters.execute(query: query, page: page, house: selectedHouse)
    }
}
