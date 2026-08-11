# Stargazer Journal

A Flutter app for browsing a catalog of celestial objects (stars, planets,
nebulae, galaxies) and keeping a personal journal of observations.

## Screens

1. **Explore (Home)** — searchable/filterable list (mobile) or grid
   (tablet+) of celestial objects.
2. **Star detail** — full information about one object, plus the list of
   observations already logged for it.
3. **New observation** — form to log an observation (description, date,
   time, star rating), reached from the detail screen.
4. **Settings** — light/dark theme toggle.
5. **About** *(bonus screen)* — short description of the app.

## Architecture

```
lib/
  models/      Pure Dart data classes (Star, Observation) — no Flutter/UI code
  services/    Data access & business logic (StarService, ObservationService,
               ThemeNotifier) — screens never store or fetch data themselves
  screens/     One file per screen (snake_case), kept "dumb": they display
               data and trigger actions, heavy logic stays in services
  widgets/     Reusable UI pieces (StarCard, StarSearchBar, ThemeToggle,
               AdaptiveScaffold, GlassContainer, GlassAppBar,
               StarfieldBackground, FadeSlideIn)
  utils/       Shared constants (route paths, spacing, breakpoints)
  router.dart  Single GoRouter configuration for the whole app
  main.dart    App entry point (providers, themes, MaterialApp.router)
```

- **Navigation**: [go_router] with a `ShellRoute` for the two top-level
  destinations (Explore / Settings, sharing the adaptive nav bar) and
  nested routes for `/star/:id` and `/star/:id/observe`. Every route
  transitions with a custom fade + rise-in animation.
- **State management**: [provider] with two `ChangeNotifier`s —
  `ThemeNotifier` (persisted via `shared_preferences`) and
  `ObservationService` (in-memory observation log).
- **Responsiveness**: `AdaptiveScaffold` switches between a floating
  glass `BottomNavigationBar` (< 600px) and a glass `NavigationRail`
  (>= 600px); the Explore screen switches between a `ListView` and a
  multi-column `GridView` at the same breakpoint.
- **Forms & validation**: `ObservationFormScreen` uses a
  `GlobalKey<FormState>`, a validated `TextFormField` for the
  description, and two custom `FormField`s (backed by `showDatePicker`
  / `showTimePicker`) for the date and time — all three are required.

## Visual style

The UI is built around one reusable building block, `GlassContainer`
(`widgets/glass_container.dart`): a blurred (`BackdropFilter`),
semi-transparent panel with a thin glowing border, used consistently
for cards, hero panels, the app bar and the navigation bar. Behind
everything sits `StarfieldBackground`, a single animated starfield
mounted once in `MaterialApp.builder` so it keeps running smoothly
across every screen instead of restarting on navigation. Screens use a
fade + rise-in transition (`router.dart`), list/grid items cascade in
with `FadeSlideIn`, star thumbnails use a shared `Hero` between the
list and detail screens, and small details (the theme toggle icon, the
rating stars) animate on change. Text is set in **JetBrains Mono**
throughout (`google_fonts`), and the palette stays to a single accent
color derived via `ColorScheme.fromSeed` — the futuristic feel comes
from blur, glow and motion rather than from many colors.

No bundled image assets are needed to run the app: celestial objects
are rendered with vector icons over the glass panels
(`widgets/star_card.dart`), so there's nothing to download or
configure before running it.

## Continuous integration

`.github/workflows/ci.yml` runs on every push/PR to `main`: it sets up
Flutter, runs `flutter pub get`, then `flutter analyze` and
`flutter test`, so lint issues and failing tests are caught
automatically.

## Getting started

```bash
flutter pub get
flutter run
```

Run the tests with:

```bash
flutter test
```

## Screenshots

_Add screenshots here (light and dark theme, mobile and tablet layout)
once you've run the app._
