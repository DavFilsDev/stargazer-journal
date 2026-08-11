class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String settings = '/settings';
  static const String about = '/about';

  static String starDetail(String id) => '/star/$id';

  static String addObservation(String id) => '/star/$id/observe';
}

class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 600;
}

class AppSpacing {
  AppSpacing._();

  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}
