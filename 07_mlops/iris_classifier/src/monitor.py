from sklearn.datasets import load_iris
import numpy as np

data = load_iris()
ruido = np.random.normal(0, 0.5, data.data.shape)
data_produccion = data.data + ruido

import pandas as pd

columnas = data.feature_names
df_entrenamiento = pd.DataFrame(data.data, columns=columnas)
df_produccion = pd.DataFrame(data_produccion, columns=columnas)

from evidently import Report
from evidently.presets import DataDriftPreset

#  crea un reporte. Le dices qué quieres analizar —>
# en este caso DataDriftPreset que es un conjunto de métricas preconfiguradas para detectar drift.
#  La lista permite añadir varios tipos de análisis a la vez.
report = Report([DataDriftPreset()])
my_eval = report.run(df_produccion, df_entrenamiento)
my_eval.save_html("drift_report.html")