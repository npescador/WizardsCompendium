import SwiftUI

@MainActor
@Observable
final class LibraryCoordinator {
    var path = NavigationPath()
    private let dependencies: LibraryDetailDependencies

    init(dependencies: LibraryDetailDependencies) {
        self.dependencies = dependencies
    }

    func push(_ route: LibraryRoute) {
        path.append(route)
    }

    @ViewBuilder
    func destination(for route: LibraryRoute) -> some View {
        switch route {
        case .movie(let movie):
            MovieDetailView(
                movie: movie,
                fetchDetail: dependencies.fetchMovieDetail
            )
        case .book(let book):
            BookDetailView(
                book: book,
                fetchDetail: dependencies.fetchBookDetail
            )
        }
    }
}

enum LibraryRoute: Hashable {
    case movie(Movie)
    case book(Book)
}

struct LibraryDetailDependencies {
    let fetchMovieDetail: FetchMovieDetailUseCase
    let fetchBookDetail: FetchBookDetailUseCase
}
