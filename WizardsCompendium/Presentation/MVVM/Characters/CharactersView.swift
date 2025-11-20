import SwiftUI

struct CharactersView: View {
    @State private var viewModel: CharactersViewModel

    private let repository: CharactersRepository

    init(viewModel: CharactersViewModel, repository: CharactersRepository) {
        _viewModel = State(initialValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                houseFilter
                content
            }
            .navigationTitle("Personajes")
            .toolbarTitleDisplayMode(.large)
        }
        .task {
            viewModel.onAppear()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("Reintentar") { viewModel.retry() }
            Button("Cerrar", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "wand.and.stars")
            TextField(
                "Busca un mago o bruja…",
                text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.onQueryChanged($0) }
                )
            )
            .textInputAutocapitalization(.words)
            .disableAutocorrection(true)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    private var houseFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(houses, id: \.self) { house in
                    let isSelected = viewModel.selectedHouse == house
                    Button {
                        viewModel.onHouseChanged(isSelected ? nil : house)
                    } label: {
                        Text(house ?? "Todas")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 4)
    }

    private var houses: [String?] {
        [nil, "Gryffindor", "Slytherin", "Ravenclaw", "Hufflepuff"]
    }

    private var content: some View {
        Group {
            if viewModel.characters.isEmpty && viewModel.isLoading {
                ProgressView("Cargando personajes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.characters) { character in
                    NavigationLink {
                        CharacterDetailView(
                            character: character,
                            fetchDetail: DefaultFetchCharacterDetailUseCase(
                                repo: repository
                            )
                        )
                    } label: {
                        CharacterRowView(character: character)
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(current: character)
                    }
                }
                .listStyle(.plain)

                if viewModel.isLoading && !viewModel.characters.isEmpty {
                    ProgressView()
                        .padding(.vertical, 8)
                }
            }
        }
    }
}
