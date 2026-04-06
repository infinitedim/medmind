import 'package:medmind/data/models/medication_model.dart';
import 'package:medmind/domain/entities/medication.dart';

extension MedicationModelMapper on MedicationModel {
  Medication toDomain() =>
      Medication(id: uid, name: name, dosage: dosage, frequency: frequency);
}

extension MedicationDomainMapper on Medication {
  MedicationModel toModel() => MedicationModel()
    ..uid = id
    ..name = name
    ..dosage = dosage
    ..frequency = frequency;
}
