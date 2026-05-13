# demostramos que el modelo funciona sin reentrenar solo cargandolo
import joblib
import numpy as np 
from config import MODEL_PATH

ejemplo = np.array([[5 ,2, 4, 1]]) # recordamos que predict espera un array 2D, no un array 1D

model = joblib.load(MODEL_PATH)

prediccion = model.predict(ejemplo)

print(prediccion) # predice 1 es decir versicolor


from sklearn.datasets import load_iris

clases = load_iris().target_names
print(f"La clase predicha es {clases[prediccion[0]]}")