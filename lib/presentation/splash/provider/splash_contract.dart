class SplashState {
  final bool isLoading;

  SplashState({this.isLoading = false});

  SplashState copyWith({bool? isLoading}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class SplashEffect { }
class NavigateTo extends SplashEffect {
  final String route;
  NavigateTo(this.route);
}
