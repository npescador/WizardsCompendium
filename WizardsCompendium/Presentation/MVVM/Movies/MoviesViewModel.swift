import Foundation
import Observation

@MainActor
@Observable
final class MoviesViewModel {
    var movies: [Movie] = []
    var isLoading = false
    var errorMessage: String?
    var query: String = ""
    var page: Int = 1
    var canLoadMore: Bool = true

    private let fetchMovies: FetchMoviesUseCase
    private let searchMovies: SearchMoviesUseCase

    init(fetchMovies: FetchMoviesUseCase, searchMovies: SearchMoviesUseCase) {
        self.fetchMovies = fetchMovies
        self.searchMovies = searchMovies
    }

    func onAppear() {
        guard movies.isEmpty else { return }
        Task { await loadInitial() }
    }

    func onQueryChanged(_ text: String) {
        query = text
        Task { await loadInitial() }
    }

    func loadMoreIfNeeded(current item: Movie) {
        guard let last = movies.last, last.id == item.id else { return }
        Task { await loadNextPage() }
    }

    func retry() {
        Task { await loadInitial() }
    }

    private func loadInitial() async {
        page = 1
        canLoadMore = true
        movies.removeAll()
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
                movies.append(contentsOf: items)
                page += 1
            }
        } catch {
            errorMessage = "No se pudieron cargar las películas."
        }
    }

    private func fetchPage(for page: Int) async throws -> [Movie] {
        if query.isEmpty {
            return try await fetchMovies.execute(page: page)
        } else {
            return try await searchMovies.execute(query: query, page: page)
        }
    }
}
