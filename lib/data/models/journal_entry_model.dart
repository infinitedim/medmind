import 'package:isar/isar.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'journal_entry_model.g.dart';

@Embedded()
class SymptomLogEmbed {
  late String symptomId;
  late int severity;
  int? onsetHour;
  int? onsetMinute;
  int? durationMinutes;
  String? notes;
}

@Embedded()
class MedicationLogEmbed {
  late String medicationId;
  late bool taken;

  int? timeHour;
  int? timeMinute;

  String? dosage;
}

@Embedded()
class SleepRecordEmbed {
  late int bedTimeMs;
  late int wakeTimeMs;
  late int quality;
  int? disturbances;
}

@Embedded()
class LifestyleFactorLogEmbed {
  late String factorId;
  bool? boolValue;
  double? numericValue;
  int? scaleValue;
}

@Embedded()
class ExtractedSymptomEmbed {
  late String symptomName;
  String? severity;
  late double confidence; // 0.0–1.0
  late String sourceText;
  bool? isConfirmedByUser;
}

@Collection()
class JournalEntryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  Mood? mood;

  int? moodIntensity;

  late List<SymptomLogEmbed> symptoms;
  late List<MedicationLogEmbed> medications;
  SleepRecordEmbed? sleepRecord;
  late List<LifestyleFactorLogEmbed> lifestyleFactors;

  String? freeText;
  List<ExtractedSymptomEmbed>? extractedSymptoms;

  @Enumerated(EnumType.name)
  ActivityLevel? activityLevel;

  late DateTime createdAt;
  late DateTime updatedAt;
}
