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

    private let fetchCharacters: FetchCharactersUseCase
    private let searchCharacters: SearchCharactersUseCase

    init(
        fetchCharacters: FetchCharactersUseCase,
        searchCharacters: SearchCharactersUseCase
    ) {
        self.fetchCharacters = fetchCharacters
        self.searchCharacters = searchCharacters
    }

    func onAppear() {
        guard characters.isEmpty else { return }
        Task { await loadInitial() }
    }

    func onQueryChanged(_ text: String) {
        query = text
        Task { await loadInitial() }
    }

    func loadMoreIfNeeded(current item: Character) {
        guard let last = characters.last, last.id == item.id else { return }
        Task { await loadNextPage() }
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
        try await fetchCharacters.execute(page: page)
    }

    private func searchCharactersPage(_ page: Int, query: String) async throws -> [Character] {
        try await searchCharacters.execute(query: query, page: page)
    }
}
