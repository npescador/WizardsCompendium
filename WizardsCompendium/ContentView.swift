//
//  ContentView.swift
//  WizardsCompendium
//
//  Created by Ignacio Pescador Ruiz on 20/11/25.
//

import SwiftUI

struct ContentView: View {
    private let viewModel: CharactersViewModel

    init() {
        let client = PotterDBClient()
        let repository = RemoteCharactersRepository(client: client)
        let fetch = DefaultFetchCharactersUseCase(repo: repository)
        let search = DefaultSearchCharactersUseCase(repo: repository)
        self.viewModel = CharactersViewModel(
            fetchCharacters: fetch,
            searchCharacters: search
        )
    }

    var body: some View {
        CharactersView(viewModel: viewModel)
    }
}

#Preview {
    CharactersView(
        viewModel: CharactersViewModel(
            fetchCharacters: PreviewCharactersRepository(),
            searchCharacters: PreviewCharactersRepository()
        )
    )
}

private final class PreviewCharactersRepository: CharactersRepository, FetchCharactersUseCase, SearchCharactersUseCase {
    func execute(page: Int) async throws -> [Character] { try await fetchCharacters(page: page) }
    func execute(query: String, page: Int) async throws -> [Character] { try await searchCharacters(query: query, page: page) }

    func fetchCharacters(page: Int) async throws -> [Character] { Self.sample }
    func searchCharacters(query: String, page: Int) async throws -> [Character] { Self.sample.filter { $0.name.lowercased().contains(query.lowercased()) } }
    func fetchCharacterDetail(idOrSlug: String) async throws -> Character { Self.sample[0] }

    private static let sample: [Character] = [
        Character(
            id: "1",
            name: "Harry Potter",
            house: "Gryffindor",
            species: "Human",
            patronus: "Stag",
            imageURL: nil,
            titles: ["The Boy Who Lived"],
            jobs: ["Auror"],
            romances: ["Ginny Weasley"],
            wikiURL: nil
        ),
        Character(
            id: "2",
            name: "Hermione Granger",
            house: "Gryffindor",
            species: "Human",
            patronus: "Otter",
            imageURL: nil,
            titles: [],
            jobs: ["Minister for Magic"],
            romances: ["Ron Weasley"],
            wikiURL: nil
        )
    ]
}
