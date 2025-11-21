import SwiftUI

struct LibraryView: View {
    @State private var selection: LibrarySection = .movies
    @State private var coordinator: LibraryCoordinator
    @State private var moviesViewModel: MoviesViewModel
    @State private var booksViewModel: BooksViewModel

    init(
        coordinator: LibraryCoordinator,
        moviesViewModel: MoviesViewModel,
        booksViewModel: BooksViewModel
    ) {
        _coordinator = State(initialValue: coordinator)
        _moviesViewModel = State(initialValue: moviesViewModel)
        _booksViewModel = State(initialValue: booksViewModel)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack(spacing: 12) {
                Picker("Sección", selection: $selection) {
                    Text("Películas").tag(LibrarySection.movies)
                    Text("Libros").tag(LibrarySection.books)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .accessibilityLabel("Selector de biblioteca")

                content
            }
            .navigationDestination(for: LibraryRoute.self) { route in
                coordinator.destination(for: route)
            }
            .navigationTitle("Biblioteca")
            .toolbarTitleDisplayMode(.large)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch selection {
        case .movies:
            MoviesView(viewModel: moviesViewModel) { movie in
                coordinator.push(.movie(movie))
            }
        case .books:
            BooksView(viewModel: booksViewModel) { book in
                coordinator.push(.book(book))
            }
        }
    }
}

enum LibrarySection {
    case movies
    case books
}
