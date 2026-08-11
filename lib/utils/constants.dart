/// Centralized route path constants.
///
/// Keeping route strings in one place avoids typos and duplicated
/// hardcoded paths across screens and widgets (DRY principle).
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String settings = '/settings';
  static const String about = '/about';

  /// Builds the detail route for a given star id.
  static String starDetail(String id) => '/star/$id';

  /// Builds the "add observation" route for a given star id.
  static String addObservation(String id) => '/star/$id/observe';
}

/// Breakpoint (in logical pixels) above which the UI switches from a
/// mobile layout (BottomNavigationBar, single-column list) to a
/// tablet/desktop layout (NavigationRail, multi-column grid).
class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 600;
}

/// Shared padding / spacing constants so screens stay visually consistent.
class AppSpacing {
  AppSpacing._();

  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}
