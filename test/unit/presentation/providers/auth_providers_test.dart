// test/unit/presentation/providers/auth_providers_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/presentation/providers/auth_providers.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

import '../../../helpers/mock_repositories.dart';

void main() {
  late MockUserPreferencesRepository mockPrefs;

  setUp(() {
    registerFallbackValues();
    mockPrefs = MockUserPreferencesRepository();
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        userPreferencesRepositoryProvider.overrideWithValue(mockPrefs),
      ],
    );
  }

  group('BiometricEnabledNotifier', () {
    test(
      'build reads isBiometricEnabled from repo and returns value',
      () async {
        when(
          () => mockPrefs.isBiometricEnabled(),
        ).thenAnswer((_) async => const Right(true));

        final container = makeContainer();
        addTearDown(container.dispose);

        final value = await container.read(
          biometricEnabledNotifierProvider.future,
        );

        expect(value, isTrue);
        verify(() => mockPrefs.isBiometricEnabled()).called(1);
      },
    );

    test('build defaults to false on repo failure', () async {
      when(() => mockPrefs.isBiometricEnabled()).thenAnswer(
        (_) async => const Left(DatabaseFailure('prefs unavailable')),
      );

      final container = makeContainer();
      addTearDown(container.dispose);

      final value = await container.read(
        biometricEnabledNotifierProvider.future,
      );

      expect(value, isFalse);
    });

    test(
      'toggle(enabled: true) calls setBiometricEnabled and updates state',
      () async {
        when(
          () => mockPrefs.isBiometricEnabled(),
        ).thenAnswer((_) async => const Right(false));
        when(
          () => mockPrefs.setBiometricEnabled(enabled: true),
        ).thenAnswer((_) async => const Right(null));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(biometricEnabledNotifierProvider.future);
        await container
            .read(biometricEnabledNotifierProvider.notifier)
            .toggle(enabled: true);

        verify(() => mockPrefs.setBiometricEnabled(enabled: true)).called(1);
        expect(
          container.read(biometricEnabledNotifierProvider).requireValue,
          isTrue,
        );
      },
    );

    test(
      'toggle(enabled: false) calls setBiometricEnabled and updates state',
      () async {
        when(
          () => mockPrefs.isBiometricEnabled(),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockPrefs.setBiometricEnabled(enabled: false),
        ).thenAnswer((_) async => const Right(null));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(biometricEnabledNotifierProvider.future);
        await container
            .read(biometricEnabledNotifierProvider.notifier)
            .toggle(enabled: false);

        verify(() => mockPrefs.setBiometricEnabled(enabled: false)).called(1);
        expect(
          container.read(biometricEnabledNotifierProvider).requireValue,
          isFalse,
        );
      },
    );
  });

  group('PinEnabledNotifier', () {
    test('build reads isPinEnabled from repo and returns value', () async {
      when(
        () => mockPrefs.isPinEnabled(),
      ).thenAnswer((_) async => const Right(false));

      final container = makeContainer();
      addTearDown(container.dispose);

      final value = await container.read(pinEnabledNotifierProvider.future);

      expect(value, isFalse);
      verify(() => mockPrefs.isPinEnabled()).called(1);
    });

    test('build defaults to false on repo failure', () async {
      when(() => mockPrefs.isPinEnabled()).thenAnswer(
        (_) async => const Left(DatabaseFailure('prefs unavailable')),
      );

      final container = makeContainer();
      addTearDown(container.dispose);

      final value = await container.read(pinEnabledNotifierProvider.future);

      expect(value, isFalse);
    });

    test('toggle(enabled: true) calls only setPinEnabled', () async {
      when(
        () => mockPrefs.isPinEnabled(),
      ).thenAnswer((_) async => const Right(false));
      when(
        () => mockPrefs.setPinEnabled(enabled: true),
      ).thenAnswer((_) async => const Right(null));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(pinEnabledNotifierProvider.future);
      await container
          .read(pinEnabledNotifierProvider.notifier)
          .toggle(enabled: true);

      verify(() => mockPrefs.setPinEnabled(enabled: true)).called(1);
      verifyNever(() => mockPrefs.clearPin());
      expect(container.read(pinEnabledNotifierProvider).requireValue, isTrue);
    });

    test(
      'toggle(enabled: false) calls clearPin before setPinEnabled',
      () async {
        when(
          () => mockPrefs.isPinEnabled(),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockPrefs.clearPin(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockPrefs.setPinEnabled(enabled: false),
        ).thenAnswer((_) async => const Right(null));

        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(pinEnabledNotifierProvider.future);
        await container
            .read(pinEnabledNotifierProvider.notifier)
            .toggle(enabled: false);

        verify(() => mockPrefs.clearPin()).called(1);
        verify(() => mockPrefs.setPinEnabled(enabled: false)).called(1);
        expect(
          container.read(pinEnabledNotifierProvider).requireValue,
          isFalse,
        );
      },
    );
  });
}
