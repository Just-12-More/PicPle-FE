class SettingState {
  final bool isLoading;

  SettingState({this.isLoading = false});

  SettingState copyWith({bool? isLoading}) {
    return SettingState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

abstract class SettingEffect {}
class BackToLogin extends SettingEffect {}
class NavigateTo extends SettingEffect {
  final String route;
  NavigateTo(this.route);
}
class ShowToast extends SettingEffect {
  final String message;
  ShowToast(this.message);
}