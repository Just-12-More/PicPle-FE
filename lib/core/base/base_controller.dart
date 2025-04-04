import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UiState { }
abstract class UiEvent { }
abstract class UiEffect { }

class EffectManager {
  final _effectController = StreamController<UiEffect>();

  Stream<UiEffect> get effectStream => _effectController.stream;

  void postEffect(UiEffect effect) {
    if (!_effectController.isClosed) {
      _effectController.sink.add(effect);
    }
  }

  void dispose() {
    _effectController.close();
  }
}

abstract class BaseController<State extends UiState, Event extends UiEvent, Effect extends UiEffect> extends StateNotifier<State> {

  final EffectManager effectManager;

  BaseController(super.initialState, this.effectManager);

  void onEventReceived(Event event);

  void updateState(State newState) {
    state = newState;
  }

  void processEvent(Event event) {
    onEventReceived(event);
  }

  void postEffect(Effect effect) {
    effectManager.postEffect(effect);
  }

  @override
  void dispose() {
    effectManager.dispose();
    super.dispose();
  }
}