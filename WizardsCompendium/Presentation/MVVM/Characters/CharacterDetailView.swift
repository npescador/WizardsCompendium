import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                infoSection
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
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

    private var infoSection: some View {
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
