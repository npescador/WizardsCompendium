import Foundation
import Observation

@MainActor
@Observable
final class AlohomoraViewModel {
    var query: String = ""
    var isLoading: Bool = false
    var errorMessage: String?

    var characters: [Character] = []
    var spells: [Spell] = []
    var movies: [Movie] = []
    var books: [Book] = []

    private let charactersSearch: SearchCharactersUseCase
    private let spellsSearch: SearchSpellsUseCase
    private let moviesSearch: SearchMoviesUseCase
    private let booksSearch: SearchBooksUseCase

    init(
        characters: SearchCharactersUseCase,
        spells: SearchSpellsUseCase,
        movies: SearchMoviesUseCase,
        books: SearchBooksUseCase
    ) {
        self.charactersSearch = characters
        self.spellsSearch = spells
        self.moviesSearch = movies
        self.booksSearch = books
    }

    func onSubmit() {
        Task { await search() }
    }

    func clearIfEmpty(_ text: String) {
        query = text
        guard text.isEmpty else { return }
        characters = []
        spells = []
        movies = []
        books = []
    }

    private func search() async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let characters = charactersSearch.execute(query: query, page: 1, house: nil)
            async let spells = spellsSearch.execute(query: query, page: 1)
            async let movies = moviesSearch.execute(query: query, page: 1)
            async let books = booksSearch.execute(query: query, page: 1)

            self.characters = try await characters
            self.spells = try await spells
            self.movies = try await movies
            self.books = try await books
        } catch {
            errorMessage = "No se pudo completar la búsqueda."
        }
    }
}
