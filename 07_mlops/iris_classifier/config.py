# src/config.py
from pathlib import Path

# raiz del proyecto -> sube dos niveles
BASE_DIR = Path(__file__).resolve().parent # __file__ es la ruta del propio archivo config.py

# Rutas
DATA_DIR  = BASE_DIR / "data"
MODELS_DIR = BASE_DIR / "models"

# Nombre del modelo serializado
MODEL_PATH = MODELS_DIR / "modelo.pkl"

# HIPERPARÁMETROS
MODEL_PARAMS = {
    "n_estimators":100,
    "max_depth":3,
    "random_state":42,
}

# Dataset
DATASET_NAME = "iris"