import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(Movie)
        case failed(String)
    }

    var state: State = .idle

    private let movieID: String
    private let fetchDetail: FetchMovieDetailUseCase

    init(movieID: String, fetchDetail: FetchMovieDetailUseCase) {
        self.movieID = movieID
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
            let movie = try await fetchDetail.execute(idOrSlug: movieID)
            state = .loaded(movie)
        } catch {
            state = .failed("No se pudo cargar la película.")
        }
    }
}
