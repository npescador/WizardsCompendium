import SwiftUI

struct FavoritesTabView: View {
    @State private var viewModel: CharactersViewModel
    private let repository: CharactersRepository

    init(viewModel: CharactersViewModel, repository: CharactersRepository) {
        _viewModel = State(initialValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        List(favoriteCharacters) { character in
            NavigationLink {
                CharacterDetailView(
                    character: character,
                    fetchDetail: DefaultFetchCharacterDetailUseCase(repo: repository),
                    isFavorite: viewModel.favoriteIDs.contains(character.id),
                    onToggleFavorite: { viewModel.toggleFavorite(id: character.id) }
                )
            } label: {
                CharacterRowView(
                    character: character,
                    isFavorite: viewModel.favoriteIDs.contains(character.id),
                    onToggleFavorite: { viewModel.toggleFavorite(id: character.id) }
                )
            }
        }
        .task {
            viewModel.onAppear()
        }
        .overlay {
            if favoriteCharacters.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "star")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Todavía no tienes favoritos")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Favoritos")
    }

    private var favoriteCharacters: [Character] {
        viewModel.characters.filter { viewModel.favoriteIDs.contains($0.id) }
    }
}
