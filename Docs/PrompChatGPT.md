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