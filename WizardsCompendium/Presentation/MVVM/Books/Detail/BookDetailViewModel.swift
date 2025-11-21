import Foundation
import Observation

@MainActor
@Observable
final class BookDetailViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(Book)
        case failed(String)
    }

    var state: State = .idle

    private let bookID: String
    private let fetchDetail: FetchBookDetailUseCase

    init(bookID: String, fetchDetail: FetchBookDetailUseCase) {
        self.bookID = bookID
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
            let book = try await fetchDetail.execute(idOrSlug: bookID)
            state = .loaded(book)
        } catch {
            state = .failed("No se pudo cargar el libro.")
        }
    }
}
