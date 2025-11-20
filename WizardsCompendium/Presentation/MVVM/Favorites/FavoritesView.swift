import SwiftUI

struct FavoritesView: View {
    let characters: [Character]
    let onSelect: (Character) -> Void

    var body: some View {
        List(characters) { character in
            Button {
                onSelect(character)
            } label: {
                HStack {
                    Text(character.name)
                    Spacer()
                    if let house = character.house {
                        Text(house)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                }
            }
        }
        .navigationTitle("Favoritos")
    }
}
