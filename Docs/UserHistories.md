# Historias de Usuario – Wizard’s Compendium

Formato:  
**Historia**: Como [rol], quiero [objetivo] para [beneficio].  
**Criterios de aceptación**: listados detallados por historia.

---

## 1. Onboarding y configuración de casa

### HU-ONB-01 – Ver onboarding en primera apertura

**Historia**  
Como fan que abre la app por primera vez,  
quiero ver una introducción temática y el sombrero seleccionador,  
para sentir que estoy entrando en el mundo de Hogwarts.

**Criterios de aceptación**

- CA1: Cuando el usuario abre la app por primera vez, se muestra una pantalla de bienvenida.
- CA2: Si el usuario ya ha completado el onboarding anteriormente, no se vuelve a mostrar automáticamente.
- CA3: La pantalla de bienvenida debe incluir:
  - Logo de la app o elemento gráfico mágico.
  - Un botón “Comenzar” o equivalente.
- CA4: Al pulsar “Comenzar”, el usuario navega a la pantalla del Sombrero Seleccionador (HU-ONB-02).

---

### HU-ONB-02 – Elegir casa favorita

**Historia**  
Como fan,  
quiero elegir mi casa favorita,  
para que la app adapte su aspecto y me identifique con ella.

**Criterios de aceptación**

- CA1: La pantalla muestra las 4 casas: Gryffindor, Slytherin, Ravenclaw, Hufflepuff.
- CA2: Cada casa tiene:
  - Nombre.
  - Escudo o icono.
  - Breve descripción.
- CA3: El usuario puede seleccionar exactamente una casa.
- CA4: Al confirmar, la elección se guarda de forma persistente (ej. UserDefaults/SwiftData).
- CA5: La casa seleccionada se usará para ajustar el tema de colores en:
  - Barra de navegación (título, acentos).
  - Botones destacados.
- CA6: Si el usuario reinstala la app o borra datos, la elección se pierde y el onboarding vuelve a aparecer.

---

### HU-ONB-03 – Saltar onboarding

**Historia**  
Como usuario impaciente,  
quiero poder saltarme el onboarding,  
para ir directo al contenido.

**Criterios de aceptación**

- CA1: La pantalla de onboarding incluye un botón “Saltar” o equivalente.
- CA2: Al pulsar “Saltar”, el usuario se dirige directamente a la Home.
- CA3: Si el usuario se salta el onboarding, se asigna un tema por defecto (ej. Hogwarts neutro o Gryffindor).
- CA4: El onboarding no se muestra automáticamente en siguientes aperturas.

---

## 2. Explorador de personajes

### HU-CHA-01 – Ver lista de personajes

**Historia**  
Como fan,  
quiero ver un listado de personajes del mundo de Harry Potter,  
para poder explorar quién es quién de forma rápida.

**Criterios de aceptación**

- CA1: Desde la Tab “Personajes”, se muestra una lista de personajes.
- CA2: Cada item de la lista muestra al menos:
  - Nombre del personaje.
  - Casa (si está disponible).
  - Miniatura de imagen (si está disponible) o placeholder temático.
- CA3: La lista se carga desde el endpoint de PotterDB `/characters` con paginación.
- CA4: Mientras se está cargando la primera página, se muestra un indicador de carga.
- CA5: En caso de error de red, se muestra un mensaje de error y un botón “Reintentar”.
- CA6: Si la API devuelve una lista vacía, se muestra un estado “sin resultados” con mensaje acorde.

---

### HU-CHA-02 – Paginación de personajes

**Historia**  
Como usuario,  
quiero que la lista de personajes se vaya cargando poco a poco,  
para no bloquear la app con demasiados resultados a la vez.

**Criterios de aceptación**

- CA1: La app solicita la primera página al entrar en la sección de personajes.
- CA2: Al llegar cerca del final de la lista (ej. último 20%), se solicita automáticamente la siguiente página.
- CA3: Mientras se carga la siguiente página:
  - Se muestra un indicador de carga al final de la lista o en un footer.
- CA4: Si una página posterior viene vacía, se considera que no hay más resultados y se deja de paginar.
- CA5: Errores al cargar páginas posteriores:
  - No deben vaciar la lista ya descargada.
  - Deben mostrar un mensaje de error (ej. toast o banner).

---

### HU-CHA-03 – Buscar personajes por nombre

**Historia**  
Como fan que recuerda nombres,  
quiero buscar personajes por su nombre,  
para encontrar rápidamente a quien me interesa.

**Criterios de aceptación**

- CA1: En la lista de personajes debe haber un campo de búsqueda.
- CA2: Al introducir texto en el campo de búsqueda, se debe:
  - Reiniciar la paginación.
  - Realizar la consulta usando el filtro correspondiente (ej. `filter[name_cont]`).
- CA3: Mientras la búsqueda está en curso, debe mostrarse un estado de carga o indicación de que se está filtrando.
- CA4: Si la búsqueda no encuentra resultados, la lista muestra mensaje de “Sin resultados para "<texto>"”.
- CA5: Borrar el texto de búsqueda restablece la lista general (sin filtro) a partir de la primera página.

---

### HU-CHA-04 – Filtrar personajes por casa

**Historia**  
Como fan de una casa concreta,  
quiero poder filtrar personajes por casa,  
para centrarme solo en los magos y brujas de mi casa favorita.

**Criterios de aceptación**

- CA1: Debe existir un control (ej. menú o chips) para seleccionar una casa (incluyendo opción “Todas”).
- CA2: Al seleccionar una casa:
  - La lista se recarga desde la primera página.
  - Se aplica el filtro correspondiente en la API si es soportado (o filtro local si no).
- CA3: El filtro debe ser combinable con el texto de búsqueda.
- CA4: El filtro seleccionado debe permanecer activo al navegar entre lista y detalle y volver atrás.

---

### HU-CHA-05 – Ver detalle de personaje

**Historia**  
Como fan,  
quiero ver la ficha detallada de un personaje,  
para conocer más sobre su historia, casa, patronus, etc.

**Criterios de aceptación**

- CA1: Al tocar un personaje de la lista, se navega a una pantalla de detalle.
- CA2: El detalle muestra:
  - Imagen grande del personaje (o placeholder).
  - Nombre completo.
  - Casa.
  - Especie.
  - Patronus.
  - Títulos (si los hay).
  - Trabajos (jobs) significativos.
  - Romances (si existen).
- CA3: Si hay enlace a wiki (`wiki`), debe mostrarse un botón “Ver más en wiki”.
- CA4: Errores al cargar detalle (si hay llamada adicional):
  - Muestran un mensaje de error y permiten intentar de nuevo.

---

### HU-CHA-06 – Marcar personajes como favoritos

**Historia**  
Como fan,  
quiero marcar ciertos personajes como favoritos,  
para acceder rápidamente a mis preferidos.

**Criterios de aceptación**

- CA1: En la lista, cada personaje debe tener un icono/botón de favorito (estrella, corazón o similar).
- CA2: En la pantalla de detalle, también debe aparecer el control de favorito.
- CA3: Tocar el icono de favorito alterna el estado (favorito / no favorito).
- CA4: El estado de favorito se persiste localmente, de modo que:
  - Al cerrar y abrir la app, se mantiene.
- CA5: El estado debe estar sincronizado entre lista y detalle (lo que cambie en uno se refleja en el otro).
- CA6: Personajes marcados como favoritos deben aparecer en la sección de favoritos (HU-FAV-01).

---

## 3. Grimorio de hechizos

### HU-SPL-01 – Ver lista de hechizos

**Historia**  
Como fan,  
quiero ver un listado de hechizos,  
para recordar sus nombres y efectos.

**Criterios de aceptación**

- CA1: La Tab “Hechizos” muestra una lista de hechizos.
- CA2: Cada entrada muestra:
  - Nombre del hechizo.
  - Incantation (si está disponible).
  - Categoría (si aplica).
- CA3: Se carga desde el endpoint `/spells`.
- CA4: Mientras se carga, se muestra un indicador de carga.
- CA5: En caso de error, se muestra mensaje y opción de reintentar.

---

### HU-SPL-02 – Buscar hechizos

**Historia**  
Como fan,  
quiero buscar hechizos por nombre o incantation,  
para encontrar hechizos concretos rápidamente.

**Criterios de aceptación**

- CA1: La lista dispone de campo de búsqueda.
- CA2: Al escribir texto, se recarga la lista de hechizos filtrando por el campo correspondiente (según API).
- CA3: Si no hay resultados, se muestra un estado “Sin hechizos encontrados”.
- CA4: Borrar el texto de búsqueda devuelve la lista completa.

---

### HU-SPL-03 – Ver detalle de un hechizo

**Historia**  
Como fan,  
quiero ver la ficha detallada de un hechizo,  
para conocer su efecto y detalles.

**Criterios de aceptación**

- CA1: Al tocar un hechizo de la lista, se navega al detalle.
- CA2: La ficha de detalle muestra:
  - Nombre del hechizo.
  - Incantation (si existe).
  - Efecto.
  - Categoría.
  - Luz (light) si está disponible.
  - Imagen o icono temático.
- CA3: Si hay enlace a wiki, se muestra un botón para abrirla (en Safari o `SFSafariViewController`).

---

### HU-SPL-04 – Marcar hechizos como favoritos

**Historia**  
Como fan,  
quiero guardar mis hechizos favoritos,  
para acceder a ellos rápidamente cuando los necesito.

**Criterios de aceptación**

- CA1: Cada hechizo en la lista y en el detalle debe tener un botón de favorito.
- CA2: El estado de favorito se persiste localmente.
- CA3: Los hechizos favoritos se muestran en la sección de favoritos.
- CA4: El cambio de estado se refleja tanto en lista como en detalle.

---

## 4. Libros y películas

### HU-LIB-01 – Ver lista de libros

**Historia**  
Como fan,  
quiero ver un listado de libros de Harry Potter,  
para recordar las obras y sus datos principales.

**Criterios de aceptación**

- CA1: La sección de Biblioteca muestra una lista de libros obtenidos de PotterDB.
- CA2: Cada libro muestra:
  - Título.
  - Fecha de publicación (si está disponible).
  - Portada o placeholder.
- CA3: Al tocar un libro, se abre pantalla de detalle (HU-LIB-02).
- CA4: Si no hay libros, se muestra estado “Sin libros disponibles”.

---

### HU-LIB-02 – Detalle de libro

**Historia**  
Como fan,  
quiero ver información detallada de un libro,  
para recordar su contexto y datos.

**Criterios de aceptación**

- CA1: El detalle de libro muestra:
  - Título.
  - Resumen / sinopsis si existe.
  - Fecha de publicación.
  - Portada en tamaño mayor.
  - Enlace a wiki (si existe).
- CA2: Si falta algún dato, el campo se puede ocultar o indicar “No disponible”.

---

### HU-MOV-01 – Ver lista de películas

**Historia**  
Como fan,  
quiero ver un listado de películas de Harry Potter,  
para recordar cuáles forman la saga y sus datos clave.

**Criterios de aceptación**

- CA1: La sección de Biblioteca incluye listado de películas.
- CA2: Cada película muestra:
  - Título.
  - Año de estreno.
  - Póster o imagen.
- CA3: Al tocar una película, se abre detalle (HU-MOV-02).

---

### HU-MOV-02 – Detalle de película

**Historia**  
Como fan,  
quiero ver detalle de una película,  
para recordar su trama y datos.

**Criterios de aceptación**

- CA1: El detalle de película muestra:
  - Título.
  - Sinopsis / resumen.
  - Fecha de estreno.
  - Póster ampliado.
  - Enlace a wiki o tráiler (si existe URL).
- CA2: Los campos ausentes se omiten o aparecen como “No disponible”.

---

## 5. Favoritos

### HU-FAV-01 – Ver lista de favoritos

**Historia**  
Como fan,  
quiero tener una sección con mis personajes y hechizos favoritos,  
para no tener que buscarlos cada vez.

**Criterios de aceptación**

- CA1: Existe una sección o pestaña que muestra favoritos.
- CA2: Debe diferenciar al menos:
  - Personajes favoritos.
  - Hechizos favoritos.
  - (Opcional) Películas/Libros favoritos si se implementa.
- CA3: Cada item en favoritos muestra la misma información básica que en su lista original.
- CA4: Tocar un favorito navega al mismo detalle que desde la lista principal.
- CA5: Si no hay favoritos, se muestra un mensaje “Todavía no tienes favoritos”.

---

### HU-FAV-02 – Quitar elementos desde favoritos

**Historia**  
Como fan,  
quiero poder quitar elementos de favoritos desde la propia lista de favoritos,  
para mantenerla organizada.

**Criterios de aceptación**

- CA1: En la lista de favoritos, cada item tiene un control para desmarcar favorito.
- CA2: Al desmarcar, el elemento desaparece inmediatamente de la lista de favoritos.
- CA3: El cambio de estado se refleja también en la lista principal y en el detalle del recurso.

---

## 6. Búsqueda global “Alohomora”

### HU-SRC-01 – Búsqueda global desde Home

**Historia**  
Como fan,  
quiero poder buscar en personajes, hechizos y películas desde un único campo,  
para encontrar contenido sin preocuparme de en qué sección está.

**Criterios de aceptación**

- CA1: En Home hay un campo de búsqueda visible.
- CA2: Al introducir texto y confirmar (o al parar de escribir según diseño), la app lanza:
  - Búsqueda de personajes.
  - Búsqueda de hechizos.
  - Búsqueda de películas.
- CA3: Las búsquedas se pueden hacer en paralelo (Concurrent `async/await`).
- CA4: Se muestra pantalla de resultados con secciones:
  - Personajes
  - Hechizos
  - Películas
- CA5: Cada sección puede mostrar un máximo configurable de resultados (ej. 5–10).
- CA6: Tocar un resultado lleva a la pantalla de detalle correspondiente.

---

### HU-SRC-02 – Sin resultados en búsqueda global

**Historia**  
Como usuario,  
quiero recibir un mensaje claro cuando no haya resultados en ninguna categoría,  
para entender que mi búsqueda no coincide con nada.

**Criterios de aceptación**

- CA1: Si todas las listas (personajes, hechizos, películas) están vacías:
  - Se muestra un mensaje “No se han encontrado resultados”.
- CA2: Si hay resultados solo en algunas categorías:
  - Solo se muestran secciones con resultados; las vacías pueden no aparecer o mostrar “0 resultados”.

---

## 7. Errores, carga y estados vacíos

### HU-ERR-01 – Manejo de errores de red

**Historia**  
Como usuario,  
quiero que la app me informe de forma clara cuando haya problemas de conexión,  
para saber qué está ocurriendo y poder reintentar.

**Criterios de aceptación**

- CA1: Si una llamada a la API falla por red:
  - Se muestra un mensaje claro (ej. “No se ha podido conectar con el servidor”).
- CA2: Debe existir un botón “Reintentar” en las pantallas donde tenga sentido (listas principales).
- CA3: Al pulsar “Reintentar”, se repite la llamada fallida.
- CA4: Sin conexión prolongada:
  - La app no debe bloquearse; el usuario puede navegar por pantallas que no dependan de datos nuevos (ej. favoritos ya cacheados, si se implementa).

---

### HU-STAT-01 – Estados de carga

**Historia**  
Como usuario,  
quiero ver estados de carga claros,  
para entender que la app está trabajando y no está congelada.

**Criterios de aceptación**

- CA1: Al iniciar la carga de una lista principal, se muestra un `ProgressView` o indicador similar.
- CA2: Al cargar más páginas, se muestra un indicador discreto en el pie de la lista.
- CA3: Los indicadores de carga desaparecen cuando se reciben los datos o cuando hay un error.

---

### HU-STAT-02 – Estados vacíos

**Historia**  
Como usuario,  
quiero que la app muestre mensajes amigables cuando no haya contenido,  
para entender claramente que no hay datos y no es un error.

**Criterios de aceptación**

- CA1: En listas (personajes, hechizos, libros, películas):
  - Si la API devuelve 0 resultados y no hay error, se muestra un estado vacío con mensaje (ej. “No hay elementos para mostrar”).
- CA2: El estado vacío debe diferenciarse visualmente de un error (ej. sin icono de advertencia).

---

## 8. Historias técnicas (arquitectura y capas)

### HU-TECH-01 – Definir módulo Domain

**Historia**  
Como desarrollador,  
quiero tener un módulo Domain separado,  
para encapsular la lógica de negocio y mantenerla independiente de la UI.

**Criterios de aceptación**

- CA1: Existe target/módulo `WizardDomain`.
- CA2: `WizardDomain` contiene:
  - Entidades (`Character`, `Spell`, `Book`, `Movie`).
  - Protocolos de repositorio.
  - Casos de uso.
- CA3: `WizardDomain` no importa UIKit, SwiftUI ni librerías de presentación.
- CA4: Tests unitarios pueden crear dobles de repositorios (mocks/fakes) para probar casos de uso.

---

### HU-TECH-02 – Definir módulo Data

**Historia**  
Como desarrollador,  
quiero tener un módulo Data,  
para gestionar integraciones con PotterDB y adaptarlas al dominio.

**Criterios de aceptación**

- CA1: Existe target/módulo `WizardData`.
- CA2: `WizardData` contiene:
  - Cliente HTTP (PotterDBClient).
  - DTOs de respuesta JSON:API.
  - Implementaciones concretas de repositorios (e.g. `RemoteCharactersRepository`).
- CA3: `WizardData` depende de `WizardDomain` pero no de Presentation.
- CA4: Los mappers de DTO → entidades de Domain están encapsulados en este módulo.

---

### HU-TECH-03 – Variante Presentation MVVM

**Historia**  
Como desarrollador,  
quiero tener una implementación de la app con arquitectura MVVM,  
para usarla como referencia de proyecto SwiftUI moderno.

**Criterios de aceptación**

- CA1: Existe target/módulo `WizardPresentationMVVM`.
- CA2: La implementación MVVM reutiliza `WizardDomain` y `WizardData`.
- CA3: Cada feature principal tiene:
  - ViewModel (Observable/ObservableObject).
  - Vistas SwiftUI.
- CA4: No hay lógica de negocio en las vistas; las vistas delegan en el ViewModel.

---

### HU-TECH-04 – Variante Presentation MVI

**Historia**  
Como desarrollador,  
quiero tener una implementación MVI,  
para explorar un flujo de datos estrictamente unidireccional.

**Criterios de aceptación**

- CA1: Existe `WizardPresentationMVI`.
- CA2: Cada feature tiene:
  - `State`
  - `Intent/Action`
  - `Store` o similar que reduce los Intent en nuevos estados.
- CA3: Las vistas usan solo `state` y `send(intent:)` para comunicar interacciones.

---

### HU-TECH-05 – Variante Presentation VIPER

**Historia**  
Como desarrollador,  
quiero una implementación VIPER,  
para practicar separación extrema de responsabilidades y compatibilidad con UIKit.

**Criterios de aceptación**

- CA1: Existe `WizardPresentationVIPER`.
- CA2: Cada módulo de feature tiene:
  - View (UIViewController/SwiftUI wrapper).
  - Presenter.
  - Interactor.
  - Router.
  - Contracts (protocolos).
- CA3: El Interactor usa casos de uso del Domain y no accede directamente a la red.

---

### HU-TECH-06 – Variante Presentation TCA

**Historia**  
Como desarrollador,  
quiero una implementación con The Composable Architecture,  
para asegurar testabilidad máxima y composición por features.

**Criterios de aceptación**

- CA1: Existe `WizardPresentationTCA`.
- CA2: Cada feature tiene:
  - `State`, `Action`, `Reducer`.
  - Dependencias inyectadas (`@Dependency`) hacia casos de uso.
- CA3: Existen tests unitarios de reducers de al menos una feature (ej. Personajes).

---

## 9. Accesibilidad y diseño

### HU-ACC-01 – Soporte de Dynamic Type

**Historia**  
Como usuario con diferentes necesidades de lectura,  
quiero que la app respete el tamaño de texto del sistema,  
para poder leer sin dificultad.

**Criterios de aceptación**

- CA1: Los textos principales usan estilos que soportan Dynamic Type (ej. `.body`, `.title`, etc.).
- CA2: La interfaz no se rompe visualmente al aumentar el tamaño de fuente a los niveles máximos razonables.

---

### HU-ACC-02 – Contraste adecuado

**Historia**  
Como usuario,  
quiero que los textos tengan buen contraste con el fondo,  
para poder leer correctamente incluso en temas oscuros.

**Criterios de aceptación**

- CA1: Los colores de texto y fondo deben cumplir contraste suficiente (WCAG AA como referencia orientativa).
- CA2: Los temas por casa no deben generar textos ilegibles (no texto oscuro sobre fondo oscuro, etc.).

---

### HU-UX-01 – Animaciones suaves

**Historia**  
Como fan,  
quiero transiciones visuales suaves y mágicas,  
para percibir la app como una experiencia cuidada.

**Criterios de aceptación**

- CA1: Navegar de lista a detalle debe tener animación suave (por defecto de NavigationStack o personalizada ligera).
- CA2: Las animaciones no deben ser excesivamente lentas ni mareantes.
- CA3: (Opcional) Al abrir el detalle de hechizo se puede mostrar una pequeña animación temática (ej. brillo tipo “Lumos”).

---