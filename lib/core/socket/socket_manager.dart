import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

enum SocketConnectionStatus { disconnected, connecting, connected, error }

class SocketStatus {
  final SocketConnectionStatus status;
  final String? error;

  const SocketStatus._(this.status, {this.error});

  const SocketStatus.disconnected()
      : this._(SocketConnectionStatus.disconnected);

  const SocketStatus.connecting()
      : this._(SocketConnectionStatus.connecting);

  const SocketStatus.connected()
      : this._(SocketConnectionStatus.connected);

  const SocketStatus.error(String message)
      : this._(SocketConnectionStatus.error, error: message);

  bool get isConnected => status == SocketConnectionStatus.connected;
}

class SocketMessage {
  final String destination;
  final String? body;
  final Map<String, String> headers;

  const SocketMessage({
    required this.destination,
    required this.headers,
    this.body,
  });
}

class _SubscriptionRequest {
  final String destination;
  final Map<String, String>? headers;

  const _SubscriptionRequest({
    required this.destination,
    this.headers,
  });
}

class SocketManager extends StateNotifier<SocketStatus> {
  SocketManager({
    required String socketUrl,
    String? defaultDestination,
    this.reconnectDelay = const Duration(seconds: 5),
  })  : _socketUrl = socketUrl,
        _defaultDestination = defaultDestination,
        super(const SocketStatus.disconnected()) {
    final destination = _defaultDestination;
    if (destination != null) {
      subscribe(destination: destination);
    }
  }

  final String _socketUrl;
  final String? _defaultDestination;
  final Duration reconnectDelay;

  final StreamController<SocketMessage> _messageController =
      StreamController<SocketMessage>.broadcast();

  final Map<String, _SubscriptionRequest> _desiredSubscriptions = {};
  final Map<String, StompUnsubscribe> _activeSubscriptions = {};

  StompClient? _client;
  Timer? _reconnectTimer;
  bool _shouldAutoReconnect = true;
  bool _isConnecting = false;

  Stream<SocketMessage> get messages => _messageController.stream;

  Future<void> connect() async {
    if (!_shouldAutoReconnect || _client?.connected == true || _isConnecting) {
      developer.log(
        'connect skipped: autoReconnect=$_shouldAutoReconnect connected=${_client?.connected} isConnecting=$_isConnecting',
        name: 'SocketManager',
      );
      return;
    }

    _isConnecting = true;
    state = const SocketStatus.connecting();
    developer.log('Connecting to STOMP $_socketUrl', name: 'SocketManager');

    final client = StompClient(
      config: StompConfig(
        url: _socketUrl,
        onConnect: _onConnected,
        onStompError: _onStompError,
        onWebSocketError: _onWebSocketError,
        onDisconnect: _onDisconnected,
        onWebSocketDone: _onWebSocketDone,
        beforeConnect: () async {
          developer.log('Preparing STOMP connection...', name: 'SocketManager');
          await Future<void>.delayed(const Duration(milliseconds: 200));
        },
        connectionTimeout: const Duration(seconds: 5),
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
        stompConnectHeaders: const {},
        webSocketConnectHeaders: const {},
        reconnectDelay: Duration.zero,
      ),
    );

    _client = client;
    client.activate();
  }

  Future<void> pause() async {
    _shouldAutoReconnect = false;
    _cancelReconnectTimer();
    developer.log('Pausing STOMP connection', name: 'SocketManager');
    await _disconnectClient();
  }

  Future<void> reconnect() async {
    _shouldAutoReconnect = true;
    _cancelReconnectTimer();
    developer.log('Reconnecting STOMP connection', name: 'SocketManager');
    await _disconnectClient();
    await connect();
  }

  void subscribe({
    required String destination,
    Map<String, String>? headers,
  }) {
    _desiredSubscriptions[destination] =
        _SubscriptionRequest(destination: destination, headers: headers);
    _activateSubscription(destination);
  }

  void unsubscribe(String destination) {
    _desiredSubscriptions.remove(destination);
    final unsubscribe = _activeSubscriptions.remove(destination);
    unsubscribe?.call();
  }

  void send({
    required String destination,
    required String body,
    Map<String, String>? headers,
  }) {
    final client = _client;
    if (client == null || !client.connected) {
      developer.log('send skipped: client not connected', name: 'SocketManager');
      return;
    }

    developer.log(
      'Sending STOMP payload to $destination: $body',
      name: 'SocketManager',
    );
    client.send(destination: destination, headers: headers, body: body);
  }

  void _onConnected(StompFrame frame) {
    developer.log('STOMP connected: ${frame.headers}', name: 'SocketManager');
    _isConnecting = false;
    state = const SocketStatus.connected();
    _desiredSubscriptions.keys.forEach(_activateSubscription);
  }

  void _onDisconnected(StompFrame frame) {
    developer.log('STOMP disconnected by server', name: 'SocketManager');
    _handleDisconnect(scheduleReconnect: true);
  }

  void _onWebSocketDone() {
    developer.log('WebSocket closed', name: 'SocketManager');
    _handleDisconnect(scheduleReconnect: true);
  }

  void _onWebSocketError(dynamic error) {
    developer.log(
      'WebSocket error: $error',
      name: 'SocketManager',
      error: error,
    );
    state = SocketStatus.error(error.toString());
    _handleDisconnect(scheduleReconnect: true);
  }

  void _onStompError(StompFrame frame) {
    developer.log(
      'STOMP error: ${frame.body}',
      name: 'SocketManager',
      error: frame.body,
    );
    state = SocketStatus.error(frame.body ?? 'Unknown STOMP error');
    _handleDisconnect(scheduleReconnect: true);
  }

  void _activateSubscription(String destination) {
    final client = _client;
    if (client == null || !client.connected) {
      developer.log(
        'Delaying subscription for $destination until connected',
        name: 'SocketManager',
      );
      return;
    }
    if (_activeSubscriptions.containsKey(destination)) {
      return;
    }

    final request = _desiredSubscriptions[destination];
    if (request == null) return;

    developer.log('Subscribing to ${request.destination}', name: 'SocketManager');
    final unsubscribe = client.subscribe(
      destination: request.destination,
      headers: request.headers,
      callback: (frame) {
        _messageController.add(
          SocketMessage(
            destination: request.destination,
            headers: frame.headers,
            body: frame.body,
          ),
        );
      },
    );

    _activeSubscriptions[destination] = unsubscribe;
  }

  Future<void> _disconnectClient() async {
    _activeSubscriptions.clear();
    final client = _client;
    _client = null;
    client?.deactivate();
    state = const SocketStatus.disconnected();
    _isConnecting = false;
  }

  void _handleDisconnect({required bool scheduleReconnect}) {
    _activeSubscriptions.clear();
    _client?.deactivate();
    _client = null;
    if (state.status != SocketConnectionStatus.error) {
      state = const SocketStatus.disconnected();
    }
    _isConnecting = false;
    if (scheduleReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (!_shouldAutoReconnect || _reconnectTimer != null) {
      return;
    }
    developer.log(
      'Scheduling STOMP reconnect in ${reconnectDelay.inSeconds}s',
      name: 'SocketManager',
    );
    _reconnectTimer = Timer(reconnectDelay, () {
      _reconnectTimer = null;
      connect();
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  void dispose() {
    _shouldAutoReconnect = false;
    _cancelReconnectTimer();
    _messageController.close();
    _client?.deactivate();
    super.dispose();
  }
}

final socketManagerProvider =
    StateNotifierProvider<SocketManager, SocketStatus>((ref) {
  final manager = SocketManager(
    socketUrl: Config.socketUrl,
    defaultDestination: Config.socketDestination,
  );
  unawaited(manager.connect());
  return manager;
});

final socketMessagesProvider = StreamProvider<SocketMessage>((ref) {
  final manager = ref.watch(socketManagerProvider.notifier);
  return manager.messages;
});
