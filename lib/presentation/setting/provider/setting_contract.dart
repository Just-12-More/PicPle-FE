class SettingState {
  final bool isProcessing;

  SettingState({this.isProcessing = false});

  SettingState copyWith({bool? isProcessing}) {
    return SettingState(
      isProcessing: isProcessing ?? this.isProcessing,
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
