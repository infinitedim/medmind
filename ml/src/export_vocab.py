import json
from pathlib import Path
import datetime
import joblib


ROOT = Path(__file__).resolve().parents[1]
PROCESSED = ROOT / 'data' / 'processed'
ASSETS = ROOT / 'assets'


def main():
    ensure = ASSETS
    ensure.mkdir(parents=True, exist_ok=True)

    vocab = []
    labels = []
    symptoms = []

    # Load TF-IDF vocab
    tfidf_path = PROCESSED / 'text_classifier' / 'tfidf_vectorizer.pkl'
    if tfidf_path.exists():
        vec = joblib.load(tfidf_path)
        try:
            vocab = vec.get_feature_names_out().tolist()
        except Exception:
            try:
                vocab = list(vec.vocabulary_.keys())
            except Exception:
                vocab = []

    # Labels
    labels_path = PROCESSED / 'text_classifier' / 'labels.json'
    if labels_path.exists():
        with open(labels_path, 'r', encoding='utf-8') as f:
            labels = json.load(f)

    # Symptoms
    symptoms_path = PROCESSED / 'correlation' / 'symptom_names.json'
    if symptoms_path.exists():
        with open(symptoms_path, 'r', encoding='utf-8') as f:
            symptoms = json.load(f)

    payload = {
        'vocab': vocab,
        'labels': labels,
        'symptoms': symptoms,
        'anomaly_threshold': 0.05,
        'window_size': 10,
        'num_features': 4,
        'feature_names': ['heart_rate', 'spo2', 'temperature', 'respiratory_rate'],
        'scaler_min': [60.0, 95.0, 36.1, 12.0],
        'scaler_max': [100.0, 100.0, 37.2, 20.0],
        'version': '1.0.0',
        'created_at': datetime.datetime.utcnow().isoformat() + 'Z',
    }

    out = ASSETS / 'symptom_vocab.json'
    with open(out, 'w', encoding='utf-8') as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)

    print(f'Wrote {out}')


if __name__ == '__main__':
    main()
