# Iris Classifier — MLOps Demo

Proyecto de aprendizaje para entender el flujo completo de MLOps:
entrenar un modelo, serializarlo y exponerlo como API REST dentro de un contenedor Docker.

## Flujo completo

Entrenar → Serializar → API escuchando → Cliente manda JSON → Predicción en tiempo real

Y en producción:

Dockerfile → docker build (imagen) → docker run (contenedor) → API accesible

## Estructura

iris_classifier/
├── config.py        # rutas e hiperparámetros centralizados
├── src/
│   ├── __init__.py
│   ├── train.py     # entrena y serializa el modelo
│   └── predict.py   # prueba de predicción local
├── api/
│   ├── __init__.py
│   └── main.py      # servidor FastAPI
├── models/
│   └── modelo.pkl   # modelo serializado (no se sube a git)
├── Dockerfile
├── requirements.txt
└── README.md

## Cómo usar

### Sin Docker (desarrollo local)

#### 1. Entrenar el modelo
```bash
cd iris_classifier
python -m src.train
```
Entrena un RandomForestClassifier con el dataset iris y guarda el modelo
en models/modelo.pkl con joblib. Sin este paso no hay .pkl y la API falla.

#### 2. Probar predicción local
```bash
python -m src.predict
```
Carga el .pkl y predice sin reentrenar. Demuestra que la serialización funciona.

#### 3. Arrancar la API
```bash
uvicorn api.main:app --reload
```
`--reload` reinicia el servidor automáticamente al cambiar el código.
Solo para desarrollo, en producción no se usa.

#### 4. Hacer una predicción
```bash
curl -X POST http://127.0.0.1:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```
Respuesta: `{"prediccion": "setosa"}`

### Con Docker (como en producción)

#### 1. Construir la imagen
```bash
docker build -t iris-classifier .
```
Lee el Dockerfile y construye una imagen con todo dentro:
Python, dependencias, código y modelo.

#### 2. Arrancar el contenedor
```bash
docker run -p 8000:8000 iris-classifier
```
`-p 8000:8000` mapea el puerto 8000 del contenedor al 8000 de tu máquina.
Sin esto no puedes acceder a la API desde fuera del contenedor.

#### 3. Ver contenedores corriendo
```bash
docker ps
```

#### 4. Parar el contenedor
```bash
docker stop <nombre_contenedor>
```
Parar no es borrar — el contenedor sigue existiendo. Para borrarlo: `docker rm`.

#### 5. Hacer una predicción (igual que sin Docker)
```bash
curl -X POST http://127.0.0.1:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```

## El Dockerfile explicado

```dockerfile
FROM python:3.12-slim
```
Imagen base — un sistema operativo mínimo con Python 3.12 ya instalado.
`slim` significa versión ligera, sin herramientas innecesarias.

```dockerfile
WORKDIR /app
```
Crea la carpeta /app dentro del contenedor y se posiciona ahí.
Todo lo que viene después ocurre dentro de /app.

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
```
Copia el requirements PRIMERO y luego instala. El orden importa:
Docker cachea cada paso. Si no cambias el requirements, no reinstala
las dependencias en builds posteriores — mucho más rápido.

```dockerfile
COPY . .
```
Copia todo el proyecto al contenedor. Va después del pip install
para aprovechar la caché — el código cambia frecuentemente,
las dependencias no.

```dockerfile
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```
El comando que se ejecuta cuando arranca el contenedor.
`--host 0.0.0.0` es crítico — sin esto el servidor solo escucha
dentro del contenedor y no puedes acceder desde fuera.
"cuando alguien arranque un contenedor a partir de mí, ejecuta esto"

## Conceptos clave

### Serialización
Un modelo entrenado vive en RAM. Serializar es volcarlo a disco
con `joblib.dump()` para reutilizarlo sin reentrenar.
Se carga con `joblib.load()`. Formato: .pkl

### config.py
Centraliza rutas e hiperparámetros. Nada hardcodeado en el código.
Usa `pathlib.Path(__file__).resolve().parent` para rutas absolutas
que funcionan independientemente de desde dónde se ejecute el script.

### FastAPI
Framework de Python para crear APIs REST. Define rutas y lógica
de cada endpoint. Por sí solo no escucha peticiones — necesita un servidor.

### Uvicorn
El servidor web que ejecuta FastAPI. Se queda corriendo en un puerto
esperando peticiones HTTP. Sin uvicorn, FastAPI es código muerto.

### Pydantic
Valida los datos entrantes automáticamente. Si falta un campo
o viene con tipo incorrecto, rechaza la petición sin código manual.

### POST vs GET
- GET — pides información sin mandar datos
- POST — mandas datos para que el servidor los procese
Usamos POST porque mandamos los 4 valores de iris en el cuerpo.

### Endpoint
URL concreta del servidor que hace una cosa específica.
`/predict` recibe JSON con 4 valores y devuelve la clase predicha.

### Docker: imagen vs contenedor
- Imagen → plantilla (como una clase en Python). Se crea con `docker build`.
- Contenedor → instancia corriendo (como un objeto). Se crea con `docker run`.
- Un Dockerfile, una imagen, infinitos contenedores en paralelo.
- En producción se corren varios contenedores de la misma imagen
  para repartir el tráfico entre ellos.

### Por qué Docker
Sin Docker: "en mi máquina funciona" es un problema real.
Con Docker: la máquina va dentro de la caja. Funciona igual
en tu portátil, en el servidor, en la nube.