enum NavigationRoute {
  onboardingRoute("/"),
  mainRoute("/main"),
  homeRoute("/home"),
  detailRoute("/detail"),
  loginRoute("/login");

  const NavigationRoute(this.name);
  final String name;
}
