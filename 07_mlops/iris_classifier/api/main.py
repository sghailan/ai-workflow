from fastapi import FastAPI
from pydantic import BaseModel
import numpy as np
import joblib

from config import MODEL_PATH
from sklearn.datasets import load_iris

app = FastAPI() # es el objeto central-> crea el servidor-> todo lo que se define endpoints rutas se registra aqui

# Cuando alguien manda una petición a tu API, manda un JSON como este:
# json{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}
# Pydantic coge ese JSON y lo convierte en un objeto Python con atributos. 
#Si falta un campo o viene con tipo incorrecto, rechaza la petición automáticamente. 
#Tú no escribes ninguna validación manual.
class IrisInput(BaseModel): # clase Pydantic
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float


@app.post("/predict") # Le dice a FastAPI: "cuando llegue una petición HTTP POST a la ruta /predict, ejecuta la función de abajo".
# POST porque estás mandando datos (los 4 valores). Si fuera solo consultar algo sin mandar datos, sería GET.
def predict(data: IrisInput): # data es el objeto Pydantic que FastAPI construye automáticamente del JSON entrante. Dentro de la función accedes a los valores como data.sepal_length, data.sepal_width, etc.
    datos_array = np.array([[data.sepal_length, data.sepal_width, data.petal_length, data.petal_width]])
    model = joblib.load(MODEL_PATH)
    prediccion = model.predict(datos_array)
    clases = load_iris().target_names
    
    return {"prediccion": clases[prediccion[0]]}



# Nota FastAPI es solo el framework — define las rutas y la lógica, pero por sí solo no escucha peticiones.
# Uvicorn es el servidor web — el proceso que se queda corriendo, escucha en un puerto (por defecto el 8000), 
# y cuando llega una petición HTTP se la pasa a FastAPI para que la procese.