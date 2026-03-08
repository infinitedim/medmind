// test/helpers/pump_app.dart
// Helper extension untuk mempermudah rendering widget dalam test.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/app/theme/app_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension PumpApp on WidgetTester {
  /// Wrap widget dengan MaterialApp + Riverpod ProviderScope.
  /// Gunakan [overrides] untuk inject mock provider.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(theme: AppTheme.dark, home: widget),
      ),
    );
  }

  /// Pump dan settle sekaligus — berguna untuk async widget.
  Future<void> pumpAppAndSettle(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await pumpApp(widget, overrides: overrides);
    await pumpAndSettle();
  }
}
