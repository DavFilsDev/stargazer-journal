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
               AdaptiveScaffold)
  utils/       Shared constants (route paths, spacing, breakpoints)
  router.dart  Single GoRouter configuration for the whole app
  main.dart    App entry point (providers, themes, MaterialApp.router)
```

- **Navigation**: [go_router] with a `ShellRoute` for the two top-level
  destinations (Explore / Settings, sharing the adaptive nav bar) and
  nested routes for `/star/:id` and `/star/:id/observe`.
- **State management**: [provider] with two `ChangeNotifier`s —
  `ThemeNotifier` (persisted via `shared_preferences`) and
  `ObservationService` (in-memory observation log).
- **Responsiveness**: `AdaptiveScaffold` switches between a
  `BottomNavigationBar` (< 600px) and a `NavigationRail` (>= 600px); the
  Explore screen switches between a `ListView` and a multi-column
  `GridView` at the same breakpoint.
- **Forms & validation**: `ObservationFormScreen` uses a
  `GlobalKey<FormState>`, a validated `TextFormField` for the
  description, and two custom `FormField`s (backed by `showDatePicker`
  / `showTimePicker`) for the date and time — all three are required.

No bundled image assets are needed to run the app: celestial objects are
rendered with vector icons on colored gradients (`widgets/star_card.dart`),
so there's nothing to download or configure before running it.

## Getting started

```bash
flutter pub get
flutter run
```

Run the tests with:

```bash
flutter test
```
