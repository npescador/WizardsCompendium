# Task Log – WizardsCompendium

**Working branch:** `feature/setup-domain-data`

## Completed
- Clean Architecture base (Domain/Data): entities, repositories, use cases for characters, spells, books, movies; PotterDB client and JSON:API mappers.
- MVVM Presentation (Characters): list with pagination + search, house filter, remote detail loading with dedicated ViewModel.
- Local favorites (Characters): UserDefaults store, toggle in list and detail, synced favorite IDs.
- Commits pushed to origin:
  - `feat: add domain/data layers and mvvm characters list`
  - `feat: add house filter and detail loading for characters`
  - `feat: add local favorites support for characters`

## Pending / Next steps
- Wire FavoritesView into navigation/tab and show favorite characters.
- Global search “Alohomora” (HU-SRC): concurrent search across characters/spells/movies with grouped results.
- Spells/Books/Movies features: lists, search, basic detail; favorites per type.
- Onboarding and house theme: sorting hat, persist house, apply color palette.
- UX/Accessibility: image placeholders, empty states, Dynamic Type/contrast.
- Tests: unit tests for use cases/repositories and reducers/VM as applicable.

## Notes
- Favorites currently persist IDs only; FavoritesView relies on in-memory character models.
- No build/tests run locally on this branch.
