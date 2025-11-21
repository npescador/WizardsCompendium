import SwiftUI

struct SpellRowView: View {
    let spell: Spell
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            icon
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(spell.name)
                    .font(.headline)
                if let incantation = spell.incantation, !incantation.isEmpty {
                    Text("'\(incantation)'")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundStyle(isFavorite ? .yellow : .secondary)
            }
        }
        .padding(.vertical, 6)
    }

    private var icon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.indigo.opacity(0.15))
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }
}
