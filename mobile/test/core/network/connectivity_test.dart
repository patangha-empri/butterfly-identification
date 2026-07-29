import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import '../../mocks/mock_services.dart';

void main() {
  group('MockConnectivityService', () {
    late MockConnectivityService service;

    setUp(() {
      service = MockConnectivityService();
    });

    tearDown(() => service.dispose());

    test('initial status is online', () {
      expect(service.isOnline, isTrue);
    });

    test('emits offline when set offline', () async {
      expectLater(
        service.statusStream,
        emits(ConnectivityStatus.offline),
      );
      service.setStatus(ConnectivityStatus.offline);
    });

    test('currentStatus matches set status', () async {
      service.setStatus(ConnectivityStatus.limited);
      final status = await service.currentStatus;
      expect(status, ConnectivityStatus.limited);
    });

    test('isOnline false when offline', () {
      service.setStatus(ConnectivityStatus.offline);
      expect(service.isOnline, isFalse);
    });

    test('emits multiple status changes', () async {
      expectLater(
        service.statusStream,
        emitsInOrder([
          ConnectivityStatus.offline,
          ConnectivityStatus.online,
        ]),
      );

      service.setStatus(ConnectivityStatus.offline);
      service.setStatus(ConnectivityStatus.online);
    });
  });
}
