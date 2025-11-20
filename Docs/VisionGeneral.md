**Rol y tono**  
Actúa como un desarrollador iOS senior, muy fan del universo Harry Potter, obsesionado tanto con la arquitectura limpia como con las buenas experiencias de usuario. Tu objetivo es diseñar y describir una app para fans de Harry Potter utilizando al máximo la API de PotterDB (docs: https://docs.potterdb.com/es) y las capacidades modernas de Swift y SwiftUI (iOS reciente: uso de `async/await`, `Observation`, `NavigationStack`, `@MainActor`, etc.).

**Contexto técnico**  
- App nativa iOS escrita en Swift y SwiftUI.  
- Arquitectura de negocio: Clean Architecture con capas **Domain / Data / Presentation**.  
- Capa de presentación: generar una versión de la app para cada una de estas arquitecturas:  
  - MVVM  
  - MVI  
  - VIPER  
  - TCA (The Composable Architecture)  
- Usa las mejores prácticas modernas de iOS: concurrencia estructurada, dependencia inyectada, testabilidad, modularización por capas y por features.

**Requisitos funcionales (a nivel de fan)**  
Diseña una app muy temática de Harry Potter que saque partido a los recursos de PotterDB:
- **Explorador de personajes**: lista con filtros por casa, búsqueda por nombre, ficha de detalle con imagen, casa, patronus, especie, romances, etc.  
- **Grimorio de hechizos**: lista de hechizos, categorías, detalle con incantation, efecto, luz del hechizo, imagen.  
- **Películas y libros**: fichas con poster/cover, sinopsis, fecha de lanzamiento, rating, etc.  
- Favoritos locales (personajes/hechizos/películas).  
- Búsqueda global tipo “Alohomora”: búsqueda en personajes, hechizos y películas a la vez.

**Requisitos de UX/UI (tema Hogwarts)**  
- Estilo visual inspirado en Hogwarts: fondos oscuros, dorados, tipografía mágica, iconografía temática.  
- Transiciones suaves temáticas (ej. al abrir detalle de un hechizo → animación tipo “lumos”).  
- Soporte modo oscuro, con colores adaptados a la casa seleccionada.  
- Pantalla de onboarding estilo “sombrero seleccionador”.

**Lo que quiero que generes**  
1. Una **visión general de la app** (navegación, features clave, módulos).  
2. El **diseño de dominio y data** compartido (entidades, repositorios, casos de uso) basado en PotterDB.  
3. Para **cada arquitectura (MVVM, MVI, VIPER, TCA)**:  
   - Estructura de módulos/capas.  
   - Diseño de la feature “Explorador de personajes”.  
   - Estado / eventos / flujos de datos.  
   - Fragmentos de código representativos.  
   - Pros y contras de cada arquitectura.  
4. Consejos para evolucionar la app: offline, notificaciones, widgets, etc.

**Estilo de respuesta**  
- Estructura clara por secciones.  
- Código Swift moderno (`async/await`, `@MainActor`, `Observation`).  
- Explicaciones orientadas a un desarrollador intermedio/avanzado.  
- Usa ejemplos concretos de endpoints de PotterDB.

## 2. Dominio + Data (Clean Architecture)

⸻

### 2.1. Entidades (Domain)

public struct Character: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let house: String?
    public let species: String?
    public let patronus: String?
    public let imageURL: URL?
    public let titles: [String]
    public let jobs: [String]
    public let romances: [String]
    public let wikiURL: URL?
}

### 2.2. Repositorios (Domain)

public protocol CharactersRepository {
    func fetchCharacters(page: Int) async throws -> [Character]
    func searchCharacters(query: String, page: Int) async throws -> [Character]
    func fetchCharacterDetail(idOrSlug: String) async throws -> Character
}

### 2.3. Casos de Uso

public protocol FetchCharactersUseCase {
    func execute(page: Int) async throws -> [Character]
}

public final class DefaultFetchCharactersUseCase: FetchCharactersUseCase {
    private let repo: CharactersRepository

    public init(repo: CharactersRepository) {
        self.repo = repo
    }

    public func execute(page: Int) async throws -> [Character] {
        try await repo.fetchCharacters(page: page)
    }
}

### 2.4. Cliente PotterDB (Data)

public final class PotterDBClient {
    private let base = URL(string: "https://api.potterdb.com/v1")!

    public func get<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        var comp = URLComponents(
            url: base.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!
        comp.queryItems = query

        let (data, _) = try await URLSession.shared.data(from: comp.url!)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

### 2.5. Repositorio Remoto (Data)

public final class RemoteCharactersRepository: CharactersRepository {
    private let client: PotterDBClient

    public init(client: PotterDBClient) {
        self.client = client
    }

    public func fetchCharacters(page: Int) async throws -> [Character] {
        let res: JSONAPIListResponse<CharacterAttributesDTO> =
            try await client.get("characters",
                                 query: [URLQueryItem(name: "page[number]",
                                                      value: "\(page)")])
        return res.data.map(Self.mapFrom)
    }

    public func searchCharacters(query: String, page: Int) async throws -> [Character] {
        let res: JSONAPIListResponse<CharacterAttributesDTO> =
            try await client.get("characters",
                query: [
                    URLQueryItem(name: "filter[name_cont]", value: query),
                    URLQueryItem(name: "page[number]", value: "\(page)")
                ])
        return res.data.map(Self.mapFrom)
    }

    public func fetchCharacterDetail(idOrSlug: String) async throws -> Character {
        let res: JSONAPIListResponse<CharacterAttributesDTO> =
            try await client.get("characters/\(idOrSlug)")
        return Self.mapFrom(res.data.first!)
    }

    private static func mapFrom(item: JSONAPIListResponse<CharacterAttributesDTO>.Item)
    -> Character {
        let dto = item.attributes
        return Character(
            id: item.id,
            name: dto.name,
            house: dto.house,
            species: dto.species,
            patronus: dto.patronus,
            imageURL: dto.image.flatMap(URL.init),
            titles: dto.titles ?? [],
            jobs: dto.jobs ?? [],
            romances: dto.romances ?? [],
            wikiURL: dto.wiki.flatMap(URL.init)
        )
    }
}

## 3. Feature Personajes en Cada Arquitectura

Aquí tienes la estructura base, código representativo y pros/contras para:

✔ MVVM
✔ MVI
✔ VIPER
✔ TCA

⸻

## 3. Feature Personajes en Cada Arquitectura

Aquí tienes la estructura base, código representativo y pros/contras para:

✔ MVVM
✔ MVI
✔ VIPER
✔ TCA

⸻

## 3.1. Arquitectura MVVM

Estructura

PresentationMVVM/
  Characters/
    CharactersView.swift
    CharactersViewModel.swift
    CharacterDetailView.swift


⸻

CharactersViewModel (SwiftUI + @Observable)

@MainActor
@Observable
final class CharactersViewModel {
    var characters: [Character] = []
    var isLoading = false
    var errorMessage: String?
    var query = ""
    var page = 1
    var canLoadMore = true

    private let fetch: FetchCharactersUseCase
    private let search: SearchCharactersUseCase

    init(fetch: FetchCharactersUseCase, search: SearchCharactersUseCase) {
        self.fetch = fetch
        self.search = search
    }

    func onAppear() {
        if characters.isEmpty {
            Task { await loadInitial() }
        }
    }

    func onQueryChanged(_ text: String) {
        query = text
        page = 1
        Task { await loadInitial() }
    }

    func loadInitial() async {
        characters = []
        canLoadMore = true
        await loadPage()
    }

    private func loadPage() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let items = try await useCase().execute(page: page)
            if items.isEmpty { canLoadMore = false }
            characters += items
        } catch {
            errorMessage = "Error cargando personajes"
        }
    }

    private func useCase() -> any FetchCharactersUseCase {
        query.isEmpty ? fetch : search
    }
}


⸻

CharactersView

struct CharactersView: View {
    @State private var viewModel: CharactersViewModel

    init(viewModel: CharactersViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                listContent
            }
            .navigationTitle("Personajes")
        }
        .task { viewModel.onAppear() }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "wand.and.stars")
            TextField("Busca un mago o bruja…", text: Binding(
                get: { viewModel.query },
                set: { viewModel.onQueryChanged($0) }
            ))
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    private var listContent: some View {
        List(viewModel.characters) { character in
            NavigationLink {
                CharacterDetailView(character: character)
            } label: {
                Text(character.name)
            }
        }
    }
}


⸻

Pros MVVM
	•	Muy natural con SwiftUI.
	•	Poco código “ritual”.
	•	Buen equilibrio simplicidad/estructura.

Contras
	•	El ViewModel puede crecer demasiado.
	•	Manejo de efectos y estado no siempre es explícito.

## 3.2. Arquitectura MVI

⸻

State
struct CharactersState: Equatable {
    var characters: [Character] = []
    var isLoading = false
    var query = ""
    var page = 1
    var canLoadMore = true
    var errorMessage: String?
}


⸻

Intent
enum CharactersIntent {
    case onAppear
    case queryChanged(String)
    case loadMore(Character)
    case charactersLoaded(Result<[Character], Error>, page: Int)
}

⸻

Store

(código resumido)
@MainActor
final class CharactersStore: ObservableObject {
    @Published private(set) var state = CharactersState()

    private let fetch: FetchCharactersUseCase
    private let search: SearchCharactersUseCase

    func send(_ intent: CharactersIntent) {
        switch intent {
        case .onAppear:
            state.page = 1
            load(page: 1)

        case let .queryChanged(text):
            state.query = text
            state.page = 1
            load(page: 1)

        case let .loadMore(current):
            guard state.characters.last?.id == current.id else { return }
            state.page += 1
            load(page: state.page)

        case let .charactersLoaded(result, page):
            state.isLoading = false
            switch result {
            case .success(let items):
                if page == 1 { state.characters = items }
                else { state.characters += items }
            case .failure:
                state.errorMessage = "Error cargando personajes"
            }
        }
    }

    private func load(page: Int) {
        state.isLoading = true
        Task {
            do {
                let items = try await currentUseCase().execute(page: page)
                await send(.charactersLoaded(.success(items), page: page))
            } catch {
                await send(.charactersLoaded(.failure(error), page: page))
            }
        }
    }

    private func currentUseCase() -> any FetchCharactersUseCase {
        state.query.isEmpty ? fetch : search
    }
}


⸻

Pros MVI
	•	Flujo unidireccional claro.
	•	Estado centralizado y predecible.
	•	Testing sencillo del reducer.

Contras
	•	Más verboso que MVVM.
	•	No tan estándar en equipos no familiarizados.

⸻

## 3.3. Arquitectura VIPER

⸻

Estructura
Characters/
  CharactersViewController.swift
  CharactersPresenter.swift
  CharactersInteractor.swift
  CharactersRouter.swift
  CharactersContracts.swift


⸻

Interactor
func loadCharacters(page: Int, query: String?) {
    Task {
        do {
            let items = try await (query?.isEmpty ?? true)
                ? fetch.execute(page: page)
                : search.execute(query: query!, page: page)
            await MainActor.run {
                output?.didLoadCharacters(items, page: page)
            }
        } catch {
            await MainActor.run {
                output?.didFailLoadingCharacters(error)
            }
        }
    }
}


⸻

Presenter
	•	Gestiona:
	•	estado
	•	mapeo a view models específicos
	•	comunicación con interactor y vista

⸻

Pros VIPER
	•	Capas extremadamente claras y separadas.
	•	Escalable para apps grandes UIKit.

Contras
	•	Muchísimo boilerplate.
	•	Menos natural con SwiftUI.

⸻

## 3.4. Arquitectura TCA

⸻

CharactersFeature (Reducer)
struct CharactersFeature: Reducer {
    struct State: Equatable {
        var characters: [Character] = []
        var query = ""
        var page = 1
        var isLoading = false
        var alert: String?
    }

    enum Action: Equatable {
        case onAppear
        case queryChanged(String)
        case loadMore(Character)
        case charactersResponse(Result<[Character], Error>, page: Int)
        case alertDismissed
    }

    @Dependency(\.fetchCharactersUseCase) var fetch
    @Dependency(\.searchCharactersUseCase) var search

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.page = 1
            return load(page: 1, state: state)

        case let .queryChanged(text):
            state.query = text
            state.page = 1
            return load(page: 1, state: state)

        case let .loadMore(item):
            guard state.characters.last?.id == item.id else { return .none }
            state.page += 1
            return load(page: state.page, state: state)

        case let .charactersResponse(result, page):
            state.isLoading = false
            switch result {
            case .success(let items):
                if page == 1 { state.characters = items }
                else { state.characters += items }
            case .failure:
                state.alert = "Error cargando personajes"
            }
            return .none

        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }

    private func load(page: Int, state: State) -> Effect<Action> {
        .run { [query = state.query] send in
            do {
                let items = try await (
                    query.isEmpty
                    ? fetch.execute(page: page)
                    : search.execute(query: query, page: page)
                )
                await send(.charactersResponse(.success(items), page: page))
            } catch {
                await send(.charactersResponse(.failure(error), page: page))
            }
        }
    }
}


⸻

Pros TCA
	•	Reducers ultra testeables.
	•	Ideal para apps modulares y de gran tamaño.
	•	Control absoluto de efectos.

Contras
	•	Curva de aprendizaje.
	•	Algo de boilerplate.

⸻

## 4. Evolución de la App
	•	Añadir offline-first con repositorio compuesto (SwiftData).
	•	Widgets:
	•	Personaje del día
	•	Hechizo aleatorio
	•	Notificaciones para estrenos de películas/libros.
	•	Extenderlo a macOS y visionOS sin tocar Domain/Data.
	•	Sistema de temas por casa (Gryffindor, Ravenclaw…) aplicando ColorSchemes.

⸻
