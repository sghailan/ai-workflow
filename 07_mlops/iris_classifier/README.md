# Iris Classifier — MLOps Demo

Proyecto de aprendizaje para entender el flujo completo de MLOps:

entrenar un modelo, serializarlo y exponerlo como API REST.

## Estructura

iris_classifier/
├── config.py        # rutas e hiperparámetros centralizados
├── src/
│   ├── train.py     # entrena y serializa el modelo
│   └── predict.py   # prueba de predicción local
├── api/
│   └── main.py      # servidor FastAPI
├── models/
│   └── modelo.pkl   # modelo serializado
└── README.md

## Cómo usar

### 1. Entrenar el modelo
```bash
python -m src.train
```

### 2. Arrancar la API
```bash
uvicorn api.main:app --reload
```

### 3. Hacer una predicción
```bash
curl -X POST http://127.0.0.1:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```

## Flujo

Entrenar → Serializar → API escuchando → Cliente manda JSON → Predicción en tiempo real


## Conceptos clave

### FastAPI
Framework de Python para crear APIs REST. Define las rutas y la lógica
de cada endpoint. Por sí solo no escucha peticiones — necesita un servidor.

### Uvicorn
El servidor web que ejecuta FastAPI. Se queda corriendo en un puerto
(por defecto el 8000) esperando peticiones HTTP. Sin uvicorn, FastAPI
es código muerto.

### Pydantic
Librería de validación de datos. Define qué estructura espera recibir
la API. Si llega un campo incorrecto o falta uno, rechaza la petición
automáticamente sin que escribas ninguna validación manual.

### POST vs GET
- GET — pides información sin mandar datos (ej: "dame el estado del servidor")
- POST — mandas datos para que el servidor los procese (ej: "aquí tienes
  4 valores, dime la predicción")
Usamos POST porque mandamos los valores de iris en el cuerpo de la petición.

### Endpoint
Una URL concreta del servidor que hace una cosa específica.
`/predict` es el endpoint que recibe los datos y devuelve la predicción.
Una API puede tener varios endpoints para distintas funciones.