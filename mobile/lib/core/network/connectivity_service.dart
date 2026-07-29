import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CONNECTIVITY SERVICE
/// Two-layer check:
///   1. connectivity_plus  — detects network interface (wifi/mobile/none)
///   2. internet_connection_checker_plus — verifies actual internet reachability
/// Emits ConnectivityStatus via stream for app-wide reactive consumption.
/// ─────────────────────────────────────────────────────────────────────────────

enum ConnectivityStatus {
  online,
  offline,
  limited, // has interface but no internet
}

abstract class IConnectivityService {
  Stream<ConnectivityStatus> get statusStream;
  Future<ConnectivityStatus> get currentStatus;
  bool get isOnline;
}

class ConnectivityService implements IConnectivityService {
  ConnectivityService({
    Connectivity? connectivity,
    InternetConnection? internetConnection,
  })  : _connectivity = connectivity ?? Connectivity(),
        _internetConnection = internetConnection ??
            InternetConnection.createInstance(
              checkInterval: const Duration(seconds: 5),
            ) {
    _init();
  }

  final Connectivity _connectivity;
  final InternetConnection _internetConnection;

  final BehaviorSubject<ConnectivityStatus> _statusSubject =
      BehaviorSubject<ConnectivityStatus>();

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  StreamSubscription<InternetStatus>? _internetSub;

  void _init() {
    // Monitor network interface changes
    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      (results) => _handleConnectivityChange(results),
    );

    // Monitor actual internet reachability
    _internetSub = _internetConnection.onStatusChange.listen(
      (status) {
        _isOnline = status == InternetStatus.connected;
        _statusSubject.add(
          _isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline,
        );
      },
    );

    // Emit initial state
    _checkAndEmit();
  }

  Future<void> _checkAndEmit() async {
    final status = await currentStatus;
    if (!_statusSubject.isClosed) {
      _statusSubject.add(status);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasInterface = results.any(
      (r) => r != ConnectivityResult.none,
    );
    if (!hasInterface) {
      _isOnline = false;
      _statusSubject.add(ConnectivityStatus.offline);
    }
    // Let internetConnection checker determine actual reachability
  }

  @override
  Stream<ConnectivityStatus> get statusStream =>
      _statusSubject.stream.distinct();

  @override
  Future<ConnectivityStatus> get currentStatus async {
    final results = await _connectivity.checkConnectivity();
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    if (!hasInterface) return ConnectivityStatus.offline;

    final hasInternet = await _internetConnection.hasInternetAccess;
    if (!hasInternet) return ConnectivityStatus.limited;

    return ConnectivityStatus.online;
  }

  @override
  bool get isOnline => _isOnline;

  void dispose() {
    _connectivitySub?.cancel();
    _internetSub?.cancel();
    _statusSubject.close();
  }
}
