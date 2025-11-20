import SwiftUI

struct CharacterRowView: View {
    let character: Character

    var body: some View {
        HStack(spacing: 12) {
            placeholder
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                if let house = character.house, !house.isEmpty {
                    Text(house)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.brown.opacity(0.2))
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}
