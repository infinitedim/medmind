import 'package:medmind/domain/entities/symptom.dart';

class RuleBasedSymptomExtractor {
  static const _severityHighPatterns = [
    'sangat',
    'parah',
    'berat',
    'hebat',
    'ekstrem',
    'tidak tertahankan',
    'severe',
    'extreme',
    'unbearable',
    'terrible',
    'awful',
    'intense',
  ];

  static const _severityLowPatterns = [
    'sedikit',
    'ringan',
    'agak',
    'lumayan',
    'mild',
    'slight',
    'a bit',
    'a little',
    'minor',
  ];

  static const Map<String, List<String>> _symptomKeywords = {
    'sakit kepala': [
      'sakit kepala',
      'kepala sakit',
      'pusing',
      'migrain',
      'headache',
      'migraine',
      'head pain',
      'cephalgia',
    ],
    'mual': [
      'mual',
      'ingin muntah',
      'eneg',
      'nausea',
      'nauseous',
      'queasy',
      'sick to stomach',
    ],
    'muntah': [
      'muntah',
      'memuntahkan',
      'vomit',
      'vomiting',
      'threw up',
      'throwing up',
    ],
    'diare': [
      'diare',
      'mencret',
      'buang air terus',
      'diarrhea',
      'loose stool',
      'watery stool',
    ],
    'sembelit': ['sembelit', 'susah bab', 'constipation', 'constipated'],
    'nyeri perut': [
      'sakit perut',
      'nyeri perut',
      'perut sakit',
      'kram perut',
      'stomach ache',
      'abdominal pain',
      'stomach pain',
      'stomach cramp',
      'belly ache',
    ],
    'demam': [
      'demam',
      'panas',
      'suhu tinggi',
      'fever',
      'high temperature',
      'febrile',
    ],
    'batuk': ['batuk', 'cough', 'coughing'],
    'pilek': [
      'pilek',
      'hidung tersumbat',
      'hidung meler',
      'flu',
      'runny nose',
      'stuffy nose',
      'nasal congestion',
      'cold',
    ],
    'sakit tenggorokan': [
      'sakit tenggorokan',
      'tenggorokan sakit',
      'sore throat',
      'throat pain',
      'strep',
    ],
    'sesak napas': [
      'sesak napas',
      'susah bernapas',
      'napas pendek',
      'shortness of breath',
      'breathlessness',
      'dyspnea',
      'can\'t breathe',
    ],
    'nyeri dada': [
      'nyeri dada',
      'dada sakit',
      'dada terasa berat',
      'chest pain',
      'chest tightness',
      'chest pressure',
    ],
    'jantung berdebar': [
      'jantung berdebar',
      'debaran jantung',
      'palpitasi',
      'heart palpitation',
      'palpitation',
      'racing heart',
      'heart racing',
      'heart pounding',
    ],
    'kelelahan': [
      'lelah',
      'kelelahan',
      'capek',
      'lemas',
      'tired',
      'fatigue',
      'exhausted',
      'exhaustion',
      'weary',
    ],
    'insomnia': [
      'susah tidur',
      'tidak bisa tidur',
      'insomnia',
      'sleepless',
      'can\'t sleep',
    ],
    'hipersomnia': [
      'ngantuk terus',
      'tidur berlebihan',
      'hypersomnia',
      'oversleeping',
      'excessive sleepiness',
    ],
    'cemas': [
      'cemas',
      'khawatir',
      'gelisah',
      'anxiety',
      'anxious',
      'worried',
      'nervous',
      'panic',
    ],
    'depresi': [
      'depresi',
      'sedih terus',
      'tidak bergairah',
      'depression',
      'depressed',
      'low mood',
      'hopeless',
    ],
    'nyeri punggung': [
      'sakit punggung',
      'nyeri punggung',
      'punggung sakit',
      'back pain',
      'backache',
      'lower back pain',
    ],
    'nyeri sendi': [
      'nyeri sendi',
      'sendi sakit',
      'joint pain',
      'arthralgia',
      'aching joints',
    ],
    'nyeri otot': [
      'nyeri otot',
      'otot sakit',
      'kram otot',
      'muscle pain',
      'myalgia',
      'muscle cramp',
      'muscle ache',
    ],
    'ruam kulit': [
      'ruam',
      'gatal-gatal',
      'kulit merah',
      'rash',
      'skin rash',
      'hives',
      'itching',
      'pruritus',
    ],
    'bengkak': ['bengkak', 'pembengkakan', 'edema', 'swelling', 'swollen'],
    'vertigo': [
      'vertigo',
      'berputar',
      'dizziness',
      'dizzy',
      'lightheaded',
      'spinning',
    ],
    'penglihatan kabur': [
      'penglihatan kabur',
      'mata kabur',
      'blur',
      'blurry vision',
      'blurred vision',
    ],
    'berkeringat': [
      'berkeringat',
      'keringat berlebihan',
      'sweating',
      'excessive sweating',
      'night sweats',
      'hyperhidrosis',
    ],
    'nafsu makan menurun': [
      'tidak nafsu makan',
      'nafsu makan berkurang',
      'loss of appetite',
      'anorexia',
      'not hungry',
    ],
    'berat badan turun': [
      'berat badan turun',
      'kurus',
      'weight loss',
      'losing weight',
      'losing weight unintentionally',
    ],
  };

  List<ExtractedSymptom> extractFromText(String text) {
    final normalized = text.toLowerCase();
    final results = <ExtractedSymptom>[];

    for (final entry in _symptomKeywords.entries) {
      final symptomName = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        if (normalized.contains(keyword)) {
          final severity = _detectSeverity(normalized, keyword);
          final context = _extractContext(normalized, keyword);
          results.add(
            ExtractedSymptom(
              symptomName: symptomName,
              severity: severity,
              confidence: _computeConfidence(keyword, severity),
              sourceText: context,
            ),
          );
          break;
        }
      }
    }

    return results;
  }

  String? _detectSeverity(String text, String matchedKeyword) {
    final start = text.indexOf(matchedKeyword);
    final windowStart = (start - 30).clamp(0, text.length);
    final windowEnd = (start + matchedKeyword.length + 30).clamp(
      0,
      text.length,
    );
    final window = text.substring(windowStart, windowEnd);

    for (final pattern in _severityHighPatterns) {
      if (window.contains(pattern)) return 'severe';
    }
    for (final pattern in _severityLowPatterns) {
      if (window.contains(pattern)) return 'mild';
    }
    return null;
  }

  String _extractContext(String text, String keyword) {
    final start = text.indexOf(keyword);
    final contextStart = (start - 20).clamp(0, text.length);
    final contextEnd = (start + keyword.length + 20).clamp(0, text.length);
    return text.substring(contextStart, contextEnd).trim();
  }

  double _computeConfidence(String keyword, String? severity) {
    double base = keyword.split(' ').length > 1 ? 0.85 : 0.70;
    if (severity != null) base += 0.05;
    return base.clamp(0.0, 1.0);
  }
}
