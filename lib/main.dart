import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/app.dart';
import 'package:medmind/core/di/injection.dart';
import 'package:medmind/data/seed/symptom_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await seedDefaultSymptoms();
  runApp(const ProviderScope(child: MedMindApp()));
}
