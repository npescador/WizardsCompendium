import SwiftUI

struct CharacterDetailView: View {
    let initialCharacter: Character
    @State private var viewModel: CharacterDetailViewModel
    var isFavorite: Bool
    var onToggleFavorite: () -> Void

    init(character: Character, fetchDetail: FetchCharacterDetailUseCase, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        self.initialCharacter = character
        _viewModel = State(initialValue: CharacterDetailViewModel(characterID: character.id, fetchDetail: fetchDetail))
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                content
            }
            .padding()
        }
        .navigationTitle(displayName)
        .toolbar {
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.load()
        }
    }

    private var displayName: String {
        switch viewModel.state {
        case .loaded(let character):
            return character.name
        default:
            return initialCharacter.name
        }
    }

    private var header: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.brown.opacity(0.2))
                .frame(height: 180)
            Image(systemName: "wand.and.stars")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Cargando detalle...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            VStack(spacing: 12) {
                Text(message)
                    .foregroundStyle(.secondary)
                Button("Reintentar") { viewModel.retry() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let character):
            infoSection(character)
        }
    }

    private func infoSection(_ character: Character) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let house = character.house {
                labeled("Casa", value: house)
            }
            if let species = character.species {
                labeled("Especie", value: species)
            }
            if let patronus = character.patronus {
                labeled("Patronus", value: patronus)
            }
            if !character.titles.isEmpty {
                labeled("Títulos", value: character.titles.joined(separator: ", "))
            }
            if !character.jobs.isEmpty {
                labeled("Trabajos", value: character.jobs.joined(separator: ", "))
            }
            if !character.romances.isEmpty {
                labeled("Romances", value: character.romances.joined(separator: ", "))
            }
            if let wiki = character.wikiURL {
                Link("Ver en Wiki", destination: wiki)
                    .font(.headline)
                    .padding(.top, 6)
            }
        }
    }

    private func labeled(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}
