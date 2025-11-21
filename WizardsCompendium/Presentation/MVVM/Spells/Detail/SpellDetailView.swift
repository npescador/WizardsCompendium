import SwiftUI

struct SpellDetailView: View {
    let initialSpell: Spell
    @State private var viewModel: SpellDetailViewModel
    @State private var isFavorite: Bool
    var onToggleFavorite: () -> Void

    init(spell: Spell, fetchDetail: FetchSpellDetailUseCase, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        self.initialSpell = spell
        _viewModel = State(initialValue: SpellDetailViewModel(spellID: spell.id, fetchDetail: fetchDetail))
        _isFavorite = State(initialValue: isFavorite)
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
            Button(action: {
                isFavorite.toggle()
                onToggleFavorite()
            }) {
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
        case .loaded(let spell):
            return spell.name
        default:
            return initialSpell.name
        }
    }

    private var header: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.indigo.opacity(0.2))
                .frame(height: 180)
            Image(systemName: "sparkles")
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
        case .loaded(let spell):
            infoSection(spell)
        }
    }

    private func infoSection(_ spell: Spell) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let incantation = spell.incantation {
                labeled("Incantation", value: incantation)
            }
            if let effect = spell.effect {
                labeled("Efecto", value: effect)
            }
            if let category = spell.category {
                labeled("Categoría", value: category)
            }
            if let light = spell.light {
                labeled("Luz", value: light)
            }
            if let wiki = spell.wikiURL {
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
