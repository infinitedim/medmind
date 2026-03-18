// test/widget/presentation/pages/settings/settings_page_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/presentation/pages/settings/settings_page.dart';
import 'package:medmind/presentation/providers/auth_providers.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockUserPreferencesRepository mockPrefs;
  late MockBiometricAuthService mockBiometricService;

  setUp(() {
    registerFallbackValues();
    mockPrefs = MockUserPreferencesRepository();
    mockBiometricService = MockBiometricAuthService();

    when(
      () => mockPrefs.isBiometricEnabled(),
    ).thenAnswer((_) async => const Right(false));
    when(
      () => mockBiometricService.isAvailable(),
    ).thenAnswer((_) async => false);
  });

  List<dynamic> baseOverrides() => [
    biometricServiceProvider.overrideWithValue(mockBiometricService),
    userPreferencesRepositoryProvider.overrideWithValue(mockPrefs),
  ];

  group('SettingsPage smoke tests', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('MedMind'), findsOneWidget);
      expect(find.text('Pengaturan'), findsOneWidget);
    });

    testWidgets('shows Journal section header', (tester) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('JOURNAL'), findsOneWidget);
    });

    testWidgets('shows Keamanan section header', (tester) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('KEAMANAN'), findsOneWidget);
    });

    testWidgets('shows Data section header', (tester) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('DATA'), findsOneWidget);
    });

    testWidgets('shows navigation tile for Pengaturan keamanan', (
      tester,
    ) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('Pengaturan keamanan'), findsOneWidget);
    });

    testWidgets('shows navigation tile for Health Connect', (tester) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('Health Connect'), findsOneWidget);
    });

    testWidgets('shows navigation tile for Ekspor data', (tester) async {
      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('Ekspor data'), findsOneWidget);
    });

    testWidgets('hides biometric switch when biometric unavailable', (
      tester,
    ) async {
      when(
        () => mockBiometricService.isAvailable(),
      ).thenAnswer((_) async => false);

      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: List.from(baseOverrides()),
      );

      expect(find.text('Kunci Biometrik'), findsNothing);
    });

    testWidgets('shows biometric switch when biometric available', (
      tester,
    ) async {
      when(
        () => mockBiometricService.isAvailable(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPrefs.isBiometricEnabled(),
      ).thenAnswer((_) async => const Right(false));

      await tester.pumpAppAndSettle(
        const SettingsPage(),
        overrides: [
          biometricServiceProvider.overrideWithValue(mockBiometricService),
          userPreferencesRepositoryProvider.overrideWithValue(mockPrefs),
        ],
      );

      expect(find.text('Kunci Biometrik'), findsOneWidget);
    });
  });
}
