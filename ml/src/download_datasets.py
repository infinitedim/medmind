import os
from datasets import load_dataset
import pandas as pd


DATASETS = {
    'gretelai/symptom_to_diagnosis': 'symptom_to_diagnosis.csv',
    'shanover/disease_symptoms_prec_full': 'disease_symptoms_prec_full.csv',
    'QuyenAnhDE/Diseases_Symptoms': 'diseases_symptoms.csv',
    'ncbi/ncbi_disease': 'ncbi_disease.csv',
    'RonalLI/symptom-based-disease-prediction-v2': 'symptom_disease_prediction.csv',
    'sweatSmile/medical-symptom-triage': 'symptom_triage.csv',
}


def ensure_dir(path: str):
    os.makedirs(path, exist_ok=True)


def save_dataset(repo_id: str, out_path: str):
    try:
        ds = load_dataset(repo_id)
        # ds can be a DatasetDict or Dataset
        if hasattr(ds, 'to_pandas'):
            df = ds.to_pandas()
        else:
            # Concatenate splits
            if isinstance(ds, dict):
                parts = []
                for k, v in ds.items():
                    try:
                        parts.append(v.to_pandas())
                    except Exception:
                        parts.append(pd.DataFrame(list(v)))
                df = pd.concat(parts, ignore_index=True)
            else:
                df = pd.DataFrame(list(ds))

        df.to_csv(out_path, index=False)
        size = os.path.getsize(out_path)
        print(f"Saved {repo_id} -> {out_path} | rows={len(df):,} cols={len(df.columns)} size={size:,} bytes")
        return True, len(df), list(df.columns), size
    except Exception as e:
        print(f"Failed {repo_id}: {e}")
        return False, 0, [], 0


def main():
    base = os.path.join(os.path.dirname(__file__), '..', 'data', 'raw')
    base = os.path.abspath(base)
    ensure_dir(base)

    summary = []
    for repo_id, fname in DATASETS.items():
        out_path = os.path.join(base, fname)
        ok, rows, cols, size = save_dataset(repo_id, out_path)
        summary.append((repo_id, ok, rows, cols, size, out_path))

    print('\nDownload summary:')
    for repo_id, ok, rows, cols, size, out_path in summary:
        status = 'OK' if ok else 'FAILED'
        print(f"- {repo_id}: {status} | rows={rows} | cols={len(cols)} | file={out_path} | size={size} bytes")


if __name__ == '__main__':
    main()
