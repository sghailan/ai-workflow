# entrenamiento de un modelo 
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
import joblib
from config import MODEL_PATH, MODEL_PARAMS# variables concretas que vamos a usar
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

data = load_iris()

print(f"El tipo de dato cargado es", type(data))
print(f"Las variables explicativas son", data.feature_names)
print(f"La variable predictora", data.target_names)
print(f"Tamaño dataset", data.data.shape)

X = data.data
Y = data.target

X_train,X_test, y_train, y_test = train_test_split(X, Y,  test_size=0.2, random_state=MODEL_PARAMS['random_state'])

model = RandomForestClassifier(n_estimators=MODEL_PARAMS['n_estimators'], max_depth= MODEL_PARAMS['max_depth'], random_state= MODEL_PARAMS['random_state'])
# model = RandomForestClassifier(**MODEL_PARAMS) análogo

model_train = model.fit(X_train, y_train) # entrenamiento con particion de entrenamiento normal

# usamos el test para predecir y ver resultados
y_pred = model.predict(X_test)
accuracy_score_test = accuracy_score(y_test, y_pred)

print(f"Metricas del modelo", accuracy_score_test)


# nos convence el modelo serializamos
joblib.dump(model, MODEL_PATH)  # serializa y guarda 
print(f"Modelo guardado en {MODEL_PATH}")

