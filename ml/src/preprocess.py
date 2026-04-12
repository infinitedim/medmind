import os
import json
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import LabelEncoder, MinMaxScaler
from sklearn.model_selection import train_test_split
import joblib


ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / 'data' / 'raw'
PROCESSED = ROOT / 'data' / 'processed'


def ensure_dir(p: Path):
    p.mkdir(parents=True, exist_ok=True)


def text_classifier_pipeline():
    src = RAW / 'symptom_to_diagnosis.csv'
    out_dir = PROCESSED / 'text_classifier'
    ensure_dir(out_dir)

    if not src.exists():
        print(f"Missing {src}, skipping text classifier pipeline")
        return

    df = pd.read_csv(src)
    if df.empty:
        print('Empty symptom_to_diagnosis.csv, skipping')
        return

    # Heuristics for text and label columns
    text_col = None
    label_col = None
    for c in df.columns:
        lc = c.lower()
        if any(k in lc for k in ('text', 'symptom', 'sentence', 'report')) and text_col is None:
            text_col = c
        if any(k in lc for k in ('diagnosis', 'disease', 'label', 'target')) and label_col is None:
            label_col = c

    if text_col is None:
        # fallback to first object column
        for c in df.columns:
            if df[c].dtype == object:
                text_col = c
                break

    if label_col is None:
        # fallback to last column
        label_col = df.columns[-1]

    texts = df[text_col].astype(str).fillna('')
    labels = df[label_col].astype(str).fillna('unknown')

    # Prefer labels that have at least 2 samples so stratified split is possible.
    label_series = df[label_col].astype(str).fillna('unknown')
    counts = label_series.value_counts()
    eligible = counts[counts >= 2].nlargest(22).index.tolist()

    if eligible:
        filtered = df[label_series.isin(eligible)]
        texts = filtered[text_col].astype(str)
        labels = filtered[label_col].astype(str)
        le = LabelEncoder()
        y = le.fit_transform(labels)
        stratify_arg = y
    else:
        # No label has >=2 samples — fall back to top labels without stratification.
        print('Warning: no label with >=2 samples found; falling back to non-stratified split')
        top_labels = label_series.nlargest(22).index.tolist()
        filtered = df[label_series.isin(top_labels)]
        texts = filtered[text_col].astype(str)
        labels = filtered[label_col].astype(str)
        le = LabelEncoder()
        y = le.fit_transform(labels)
        stratify_arg = None

    # If after filtering there's only one class, do a non-stratified split.
    unique_labels = np.unique(y)
    if stratify_arg is not None:
        # ensure the computed test set size can contain at least one sample per class
        n_test = int(np.ceil(len(y) * 0.2))
        if unique_labels.size < 2 or n_test < unique_labels.size:
            print('Warning: not enough samples per class for a stratified split with test_size=0.2; falling back to non-stratified split')
            stratify_arg = None

    X_train_text, X_test_text, y_train, y_test = train_test_split(
        texts.tolist(), y, test_size=0.2, random_state=42, stratify=stratify_arg
    )

    vectorizer = TfidfVectorizer(max_features=500, ngram_range=(1, 2))
    X_train = vectorizer.fit_transform(X_train_text).toarray()
    X_test = vectorizer.transform(X_test_text).toarray()

    np.save(out_dir / 'X_train.npy', X_train)
    np.save(out_dir / 'y_train.npy', y_train)
    np.save(out_dir / 'X_test.npy', X_test)
    np.save(out_dir / 'y_test.npy', y_test)

    joblib.dump(vectorizer, out_dir / 'tfidf_vectorizer.pkl')
    with open(out_dir / 'labels.json', 'w', encoding='utf-8') as f:
        json.dump(le.classes_.tolist(), f, ensure_ascii=False)

    print('Text classifier preprocessing done')


def correlation_pipeline():
    a = RAW / 'disease_symptoms_prec_full.csv'
    b = RAW / 'diseases_symptoms.csv'
    out_dir = PROCESSED / 'correlation'
    ensure_dir(out_dir)

    docs = []
    for p in (a, b):
        if p.exists():
            try:
                df = pd.read_csv(p)
                # guess symptoms column
                col = None
                for c in df.columns:
                    if 'symptom' in c.lower() or 'symptoms' in c.lower():
                        col = c
                        break
                if col is None:
                    # take first object column
                    for c in df.columns:
                        if df[c].dtype == object:
                            col = c
                            break
                if col is not None:
                    docs.extend(df[col].astype(str).dropna().tolist())
            except Exception:
                continue

    # Extract symptom tokens by splitting common delimiters
    symptom_set = set()
    for doc in docs:
        parts = [s.strip().lower() for s in re_split(doc)]
        for p in parts:
            if p:
                symptom_set.add(p)

    symptom_names = sorted(symptom_set)
    # Build multi-hot matrix
    rows = []
    for doc in docs:
        parts = [s.strip().lower() for s in re_split(doc)]
        row = [1 if name in parts else 0 for name in symptom_names]
        rows.append(row)

    if rows:
        matrix = np.array(rows, dtype=np.int8)
        np.save(out_dir / 'symptom_matrix.npy', matrix)
        with open(out_dir / 'symptom_names.json', 'w', encoding='utf-8') as f:
            json.dump(symptom_names, f, ensure_ascii=False)
        print('Correlation preprocessing done')
    else:
        print('No symptom documents found for correlation pipeline')


def re_split(text: str):
    # split on common delimiters
    for sep in [';', ',', '\\n', '\\r', '\\t', '|', '/']:
        text = text.replace(sep, '\n')
    return [t for t in text.split('\n') if t.strip()]


def anomaly_pipeline():
    out_dir = PROCESSED / 'anomaly'
    ensure_dir(out_dir)

    window_size = 10
    num_features = 4
    num_series = 2000

    # Feature ranges
    hr_min, hr_max = 60.0, 100.0
    spo2_min, spo2_max = 95.0, 100.0
    temp_min, temp_max = 36.1, 37.2
    rr_min, rr_max = 12.0, 20.0

    # Generate synthetic long time series and slide windows
    rng = np.random.default_rng(42)
    # We'll produce num_series windows
    windows = np.zeros((num_series, window_size, num_features), dtype=np.float32)
    for i in range(num_series):
        hr = np.clip(rng.normal(80, 6, size=window_size), hr_min, hr_max)
        spo2 = np.clip(rng.normal(98, 0.8, size=window_size), spo2_min, spo2_max)
        temp = np.clip(rng.normal(36.6, 0.25, size=window_size), temp_min, temp_max)
        rr = np.clip(rng.normal(16, 1.5, size=window_size), rr_min, rr_max)
        w = np.stack([hr, spo2, temp, rr], axis=-1)
        windows[i] = w

    # Fit MinMaxScaler per-feature across all windows
    flat = windows.reshape(-1, num_features)
    scaler = MinMaxScaler()
    scaler.fit(flat)
    scaled = scaler.transform(flat).reshape(num_series, window_size, num_features)

    np.save(out_dir / 'X_train.npy', scaled)
    scaler_params = {
        'min': scaler.data_min_.tolist(),
        'max': scaler.data_max_.tolist(),
    }
    with open(out_dir / 'scaler_params.json', 'w', encoding='utf-8') as f:
        json.dump(scaler_params, f, ensure_ascii=False)

    print('Anomaly preprocessing done')


def main():
    ensure_dir(PROCESSED)
    text_classifier_pipeline()
    correlation_pipeline()
    anomaly_pipeline()


if __name__ == '__main__':
    main()
