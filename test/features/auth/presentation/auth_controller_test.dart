import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/auth/presentation/auth_controller.dart';

void main() {
  group('AuthController', () {
    test('default state is null/unauthenticated', () {
      final container = ProviderContainer();
      final controller = container.read(authControllerProvider.notifier);

      // Should start with no user
      expect(controller.state.valueOrNull, null);
    });

    test('logout() → state remains null', () async {
      final container = ProviderContainer();
      final controller = container.read(authControllerProvider.notifier);

      // Clear any existing state first
      controller.state = const AsyncValue.data(null);

      await controller.logout();

      // After logout, should be null
      expect(controller.state.valueOrNull, null);
    });

    test('controller is instantiable via ProviderContainer', () {
      final container = ProviderContainer();
      final controller = container.read(authControllerProvider.notifier);
      expect(controller, isNotNull);
    });
  });
}