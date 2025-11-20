# SDD – Wizard’s Compendium (App Harry Potter + PotterDB)

## 0. Metadatos del documento

- Proyecto: Wizard’s Compendium – Enciclopedia mágica para fans de Harry Potter  
- Versión del SDD: 1.0  
- Autor: [Tu nombre]  
- Fecha: [AAAA-MM-DD]  
- Plataforma: iOS (iPhone, soporte futuro iPadOS/macOS opcional)  
- Tecnologías objetivo:
  - Swift 6
  - SwiftUI (últimas novedades iOS 18/19/20+ según roadmap)
  - Concurrencia: `async/await`, `Task`, `@MainActor`
  - `@Observable` / `Observation` para estado
- Arquitectura:
  - Clean Architecture (Domain / Data / Presentation)
  - Capa de presentación implementada en 4 variantes:
    - MVVM
    - MVI
    - VIPER
    - TCA (The Composable Architecture)
- Backend:
  - API PotterDB pública (REST, JSON:API):
    - Base: `https://api.potterdb.com/v1`
    - Recursos: `characters`, `spells`, `books`, `movies`

---

## 1. Visión general de la app

Wizard’s Compendium es una app para fans de Harry Potter que permite explorar de forma visual y temática:

- Personajes (magos, brujas, muggles, criaturas…)
- Hechizos
- Libros
- Películas

La app ofrecerá:

- Exploración por listas, filtros y detalle.
- Búsqueda global “Alohomora” sobre todos los recursos.
- Favoritos locales (sin login al inicio).
- Una experiencia visual ambientada en Hogwarts, con temas por casa.

---

## 2. Objetivos

### 2.1. Objetivos de usuario

- Tener una **enciclopedia mágica de bolsillo** sobre el universo Harry Potter.
- Poder descubrir y recordar información de personajes, hechizos, libros y películas.
- Personalizar parte de la experiencia según su casa favorita.
- Guardar contenido favorito para acceder rápido.

### 2.2. Objetivos de producto / técnicos

- Demostrar distintas **arquitecturas de presentación** reutilizando el mismo dominio/datos.
- Aplicar Clean Architecture, modularización y buenas prácticas modernas de iOS.
- Sentar una base fácilmente ampliable con nuevas features (quiz, trivias, offline, etc.).

---

## 3. Alcance del MVP

### 3.1. Módulos / features incluidos en el MVP

1. **Onboarding “Sombrero seleccionador”**
   - Selección de casa favorita (Gryffindor, Slytherin, Ravenclaw, Hufflepuff).
   - Guardado local de la preferencia.
   - Adaptación básica de colores de la interfaz según casa.

2. **Explorador de personajes**
   - Lista paginada de personajes desde PotterDB.
   - Filtro por casa (cuando lo permita la API).
   - Búsqueda por nombre.
   - Pantalla de detalle del personaje.

3. **Grimorio de hechizos**
   - Lista de hechizos.
   - Búsqueda por nombre.
   - Pantalla de detalle del hechizo.

4. **Biblioteca mágica (libros y películas)**
   - Listado de libros.
   - Listado de películas.
   - Pantallas de detalle básicas.

5. **Favoritos (local)**
   - Marcar/desmarcar personajes como favoritos.
   - Marcar/desmarcar hechizos como favoritos.
   - Pantalla de lista de favoritos.

6. **Búsqueda global “Alohomora”**
   - Campo de búsqueda en Home.
   - Búsqueda unificada sobre personajes / hechizos / películas.
   - Resultados agrupados por tipo.

7. **Shell de app y navegación**
   - TabBar con secciones:
     - Home
     - Personajes
     - Hechizos
     - Biblioteca/Favoritos
   - Navegación con `NavigationStack` y rutas bien definidas.

8. **Infraestructura técnica**
   - Cliente PotterDB (HTTP, JSON:API).
   - Capa Domain (entidades + casos de uso).
   - Capa Data (DTOs, mappers, repositorios remotos).
   - Capa Presentation (4 variantes).
   - Manejo básico de errores de red (mensajes de error y reintento).
   - Manejo de estados de carga (spinners, placeholders).

### 3.2. Fuera de alcance (no MVP)

- Autenticación de usuarios / perfiles remotos.
- Sincronización de favoritos en la nube.
- Modo offline completo (cache persistente sofisticada).
- Notificaciones push.
- Widgets, Live Activities.
- Quizzes, logros o gamificación avanzada.
- Soporte Android u otras plataformas.

---

## 4. Público objetivo y personas

### Persona 1 – “Fan nostálgico”
- 30–45 años, lector de los libros y seguidor de las películas.
- Quiere recordar personajes, hechizos, curiosidades.
- Uso ocasional pero recurrente (fines de semana, ratos muertos).

### Persona 2 – “Superfan enciclopédico”
- 18–35 años, muy activo en fandom.
- Quiere datos detallados, listas completas, búsquedas potentes.
- Uso frecuente.

### Persona 3 – “Curioso casual”
- No se sabe todos los detalles del lore.
- Quiere explorar de forma visual sin complicarse.
- Uso esporádico.

---

## 5. Flujos principales de usuario

### 5.1. Onboarding

1. Primera apertura de app.
2. Pantalla de bienvenida temática.
3. Pantalla “Sombrero seleccionador”:
   - El usuario elige casa favorita.
4. Tema visual se configura.
5. App muestra Home.

### 5.2. Exploración de personajes (desde tab “Personajes”)

1. Usuario entra en tab “Personajes”.
2. La app muestra listado paginado de personajes.
3. Usuario:
   - Desplaza lista (infinite scroll).
   - Aplica filtro por casa (opcional).
   - Usa buscador para nombres.
4. El usuario toca un personaje:
   - Navega a detalle.
   - Ve info y puede marcar favorito.

### 5.3. Búsqueda global “Alohomora”

1. Usuario entra en Home.
2. Usa campo de búsqueda global.
3. La app busca en personajes/hechizos/películas.
4. Se muestran resultados separados por sección (Characters / Spells / Movies).
5. Tapping en un resultado lleva al detalle correspondiente.

---

## 6. Requisitos funcionales (alto nivel)

### 6.1. Onboarding

- RF-ONB-01: La app debe mostrar onboarding solo la primera vez (o hasta que el usuario lo complete).
- RF-ONB-02: El usuario puede seleccionar una casa y guardarla.
- RF-ONB-03: El usuario puede saltar onboarding y usar un tema por defecto.

### 6.2. Personajes

- RF-CHA-01: Mostrar lista paginada de personajes.
- RF-CHA-02: Permitir búsqueda por nombre.
- RF-CHA-03: Permitir filtrar por casa.
- RF-CHA-04: Mostrar detalle de personaje con datos principales.
- RF-CHA-05: Permitir marcar/desmarcar favorito desde la lista y el detalle.

### 6.3. Hechizos

- RF-SPL-01: Mostrar lista de hechizos.
- RF-SPL-02: Permitir búsqueda por nombre de hechizo / incantation.
- RF-SPL-03: Mostrar detalle de hechizo.

### 6.4. Libros y películas

- RF-LIB-01: Mostrar lista de libros.
- RF-LIB-02: Mostrar lista de películas.
- RF-LIB-03: Mostrar detalle básico de libro/película (título, fecha, sinopsis/resumen).

### 6.5. Favoritos

- RF-FAV-01: Mantener lista local de favoritos.
- RF-FAV-02: Sección de favoritos accesible desde la app (tab o sección dentro de Biblioteca).
- RF-FAV-03: Sincronizar estados de favoritos entre lista y detalle.

### 6.6. Búsqueda global

- RF-SRC-01: Campo de búsqueda en Home.
- RF-SRC-02: Realizar búsqueda concurrente en personajes/hechizos/películas.
- RF-SRC-03: Mostrar resultados agrupados por tipo de recurso.

### 6.7. Errores y estados

- RF-ERR-01: Mostrar mensaje claro cuando falle la conexión.
- RF-ERR-02: Permitir reintentar una carga tras error.
- RF-ERR-03: Mostrar estados de “cargando” y “sin resultados”.

---

## 7. Requisitos no funcionales

### 7.1. Rendimiento

- RNF-PERF-01: La lista de personajes debe cargar la primera página en < 2–3 segundos en red 4G razonable.
- RNF-PERF-02: El scroll debe ser suave (60 fps en la mayoría de dispositivos soportados).

### 7.2. Accesibilidad

- RNF-ACC-01: Soporte de Dynamic Type en textos principales.
- RNF-ACC-02: Contraste adecuado entre texto y fondo, incluso con temas por casa.
- RNF-ACC-03: Etiquetas `accessibilityLabel` adecuadas en botones clave (favorito, búsqueda, tabs).

### 7.3. UX y diseño

- RNF-UX-01: Tema visual oscuro con acentos por casa.
- RNF-UX-02: Transiciones suaves entre lista y detalle (`matchedGeometryEffect` opcional, animaciones ligeras).
- RNF-UX-03: Iconografía temática pero usando SF Symbols cuando sea posible.

### 7.4. Código y arquitectura

- RNF-COD-01: Separación clara Domain / Data / Presentation.
- RNF-COD-02: La capa Domain no debe depender de frameworks de UI ni librerías externas.
- RNF-COD-03: Debe existir una variante de la capa Presentation por cada arquitectura (MVVM / MVI / VIPER / TCA) reutilizando Domain y Data.
- RNF-COD-04: Al menos los casos de uso y los repositórios deben ser testeables con tests unitarios.

---

## 8. Arquitectura y módulos

### 8.1. Módulos propuestos (SPM o targets internos)

- `WizardDomain`
  - Entidades: `Character`, `Spell`, `Book`, `Movie`
  - Repositorios (protocolos)
  - Casos de uso
- `WizardData`
  - DTOs
  - Cliente PotterDB
  - Implementaciones de repositorios remotos
- `WizardPresentationMVVM`
- `WizardPresentationMVI`
- `WizardPresentationVIPER`
- `WizardPresentationTCA`
- `WizardSharedUI` (estilos, colores, componentes compartidos)

### 8.2. Diagrama conceptual (texto)

- **Domain** (puro Swift)  
  Depende de: nada.

- **Data**  
  Depende de: Domain, URLSession, JSONDecoder.

- **Presentation-XXX**  
  Depende de: Domain, Data, SwiftUI (o UIKit en el caso de VIPER si se prefiere).

---

## 9. Uso de la API PotterDB

### 9.1. Endpoints clave

- `GET /characters`
  - Paginado con `page[number]`
  - Filtros con `filter[name_cont]`, etc.
- `GET /spells`
- `GET /books`
- `GET /movies`
- `GET /characters/{id}` / `GET /spells/{id}`, etc.

### 9.2. Estrategia de mapeo

- Respetar estructura JSON:API:
  - `data` → lista de objetos
  - `data[].id` + `data[].attributes`
- Mapear a entidades de Domain mediante “mappers” dedicados.

---

## 10. Riesgos y decisiones abiertas

- Calidad y completitud de datos de PotterDB (campos nulos).
- Cambios en la API pública (deprecaciones, límites).
- Elección de librería TCA (versión concreta, modo de integración SPM).
- Nivel de complejidad realmente necesario para VIPER vs TCA vs MVI.

---

## 11. Métricas de éxito (nivel producto/técnico)

- Uso:
  - nº de sesiones de usuarios (en proyecto real con analytics).
  - nº de búsquedas realizadas.
- Calidad:
  - nº de crashes (ideal ~ 0 en TestFlight).
  - % de tests unitarios cubriendo Domain/Data.
- Mantenibilidad:
  - Facilidad para añadir una nueva feature (ej. “Bestiario de criaturas”) sin romper estructura.