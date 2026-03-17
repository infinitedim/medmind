import 'package:medmind/core/di/injection.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/data/datasources/local/symptom_local_datasource.dart';
import 'package:medmind/data/models/symptom_model.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

final _defaultSymptoms = [
  (name: 'Migrain', category: SymptomCategory.neurological, icon: 'brain'),
  (name: 'Sakit kepala', category: SymptomCategory.neurological, icon: 'brain'),
  (
    name: 'Pusing / vertigo',
    category: SymptomCategory.neurological,
    icon: 'brain',
  ),
  (name: 'Kesemutan', category: SymptomCategory.neurological, icon: 'zap'),
  (name: 'Kabut otak', category: SymptomCategory.neurological, icon: 'cloud'),
  (name: 'Tremor', category: SymptomCategory.neurological, icon: 'activity'),
  (name: 'Mual', category: SymptomCategory.digestive, icon: 'thermometer'),
  (name: 'Muntah', category: SymptomCategory.digestive, icon: 'thermometer'),
  (name: 'Kembung', category: SymptomCategory.digestive, icon: 'circle'),
  (name: 'Diare', category: SymptomCategory.digestive, icon: 'droplets'),
  (name: 'Konstipasi', category: SymptomCategory.digestive, icon: 'circle'),
  (name: 'Nyeri perut', category: SymptomCategory.digestive, icon: 'zap'),
  (name: 'GERD / mulas', category: SymptomCategory.digestive, icon: 'flame'),
  (name: 'Batuk', category: SymptomCategory.respiratory, icon: 'wind'),
  (name: 'Pilek', category: SymptomCategory.respiratory, icon: 'droplets'),
  (name: 'Sesak napas', category: SymptomCategory.respiratory, icon: 'wind'),
  (
    name: 'Hidung tersumbat',
    category: SymptomCategory.respiratory,
    icon: 'wind',
  ),
  (
    name: 'Nyeri tenggorokan',
    category: SymptomCategory.respiratory,
    icon: 'zap',
  ),
  (name: 'Nyeri sendi', category: SymptomCategory.musculoskeletal, icon: 'zap'),
  (name: 'Nyeri otot', category: SymptomCategory.musculoskeletal, icon: 'zap'),
  (
    name: 'Nyeri punggung',
    category: SymptomCategory.musculoskeletal,
    icon: 'zap',
  ),
  (
    name: 'Kekakuan sendi',
    category: SymptomCategory.musculoskeletal,
    icon: 'activity',
  ),
  (
    name: 'Kelemahan otot',
    category: SymptomCategory.musculoskeletal,
    icon: 'activity',
  ),
  (name: 'Kecemasan', category: SymptomCategory.psychological, icon: 'heart'),
  (name: 'Depresi', category: SymptomCategory.psychological, icon: 'cloud'),
  (name: 'Insomnia', category: SymptomCategory.psychological, icon: 'moon'),
  (
    name: 'Kelelahan mental',
    category: SymptomCategory.psychological,
    icon: 'battery',
  ),
  (name: 'Mood buruk', category: SymptomCategory.psychological, icon: 'frown'),
  (
    name: 'Stres tinggi',
    category: SymptomCategory.psychological,
    icon: 'alert-circle',
  ),
  (name: 'Ruam kulit', category: SymptomCategory.skin, icon: 'sun'),
  (name: 'Gatal', category: SymptomCategory.skin, icon: 'zap'),
  (name: 'Jerawat', category: SymptomCategory.skin, icon: 'circle'),
  (name: 'Demam', category: SymptomCategory.general, icon: 'thermometer'),
  (
    name: 'Kelelahan / lemas',
    category: SymptomCategory.general,
    icon: 'battery',
  ),
  (
    name: 'Kehilangan nafsu makan',
    category: SymptomCategory.general,
    icon: 'minus',
  ),
  (
    name: 'Berkeringat berlebih',
    category: SymptomCategory.general,
    icon: 'droplets',
  ),
  (name: 'Jantung berdebar', category: SymptomCategory.general, icon: 'heart'),
];

Future<void> seedDefaultSymptoms() async {
  final source = getIt<SymptomLocalDataSource>();
  final count = await source.count();
  if (count > 0) return;
  final models = _defaultSymptoms.map((s) {
    return SymptomModel()
      ..uid = _uuid.v4()
      ..name = s.name
      ..category = s.category
      ..icon = s.icon
      ..isCustom = false;
  }).toList();
  await source.saveAll(models);
}
