# Iris Classifier — MLOps Demo

Proyecto de aprendizaje para entender el flujo completo de MLOps:
entrenar un modelo, serializarlo, exponerlo como API REST, contenerizarlo con Docker
y desplegarlo en la nube con AWS EC2.

---

## Flujo completo

```
Entrenar → Serializar → API escuchando → Contenerizar → Docker Hub → AWS EC2 → Predicción desde cualquier lugar del mundo
```

---

## Estructura del proyecto

```
iris_classifier/
├── config.py        # rutas e hiperparámetros centralizados
├── src/
│   ├── __init__.py  # convierte src/ en paquete Python
│   ├── train.py     # entrena y serializa el modelo
│   ├── predict.py   # prueba de predicción local
│   └── monitor.py   # detección de drift con Evidently
├── api/
│   ├── __init__.py  # convierte api/ en paquete Python
│   └── main.py      # servidor FastAPI
├── models/
│   └── modelo.pkl   # modelo serializado (no se sube a git)
├── Dockerfile
├── requirements.txt
└── README.md
```

---

## Paso 1 — Serialización

Un modelo entrenado vive en RAM. Si el proceso termina, el modelo desaparece
y hay que reentrenar desde cero. Serializar es volcar el modelo a disco en
formato `.pkl` para reutilizarlo sin reentrenar.

### config.py
Centraliza todas las rutas e hiperparámetros. Nada hardcodeado en el código.

```python
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent  # raíz del proyecto, siempre absoluta
MODELS_DIR = BASE_DIR / "models"
MODEL_PATH = MODELS_DIR / "modelo.pkl"

MODEL_PARAMS = {
    "n_estimators": 100,
    "max_depth": 3,
    "random_state": 42,
}
```

`Path(__file__).resolve().parent` siempre apunta a la raíz del proyecto
independientemente de desde dónde se ejecute el script. A diferencia de `../../`
que es relativa al directorio de ejecución y puede fallar.

### train.py
Entrena el modelo y lo guarda en disco.

```python
joblib.dump(model, MODEL_PATH)   # serializa y guarda
joblib.load(MODEL_PATH)          # carga sin reentrenar
```

### Cómo ejecutar
```bash
cd iris_classifier
python -m src.train    # entrena y serializa
python -m src.predict  # carga el .pkl y predice sin reentrenar
```

Se usa `python -m src.train` en vez de `python src/train.py` porque así
Python toma `iris_classifier/` como raíz y encuentra `config.py` correctamente.

---

## Paso 2 — API REST con FastAPI

Una API REST permite que cualquier aplicación (web, móvil, otro servidor)
mande datos y reciba predicciones en tiempo real via HTTP.
Sin API, el modelo solo funciona como script local.

### ¿Qué es REST?
Estilo arquitectónico que usa HTTP con verbos (GET, POST...) y respuestas en JSON.
- **GET** — pides información sin mandar datos
- **POST** — mandas datos para que el servidor los procese

Usamos POST porque mandamos los 4 valores de iris en el cuerpo de la petición.

### FastAPI y Uvicorn
- **FastAPI** — framework que define las rutas y la lógica de cada endpoint.
  Por sí solo no escucha peticiones, necesita un servidor.
- **Uvicorn** — el servidor web que ejecuta FastAPI. Se queda corriendo en
  un puerto esperando peticiones HTTP. Sin uvicorn, FastAPI es código muerto.

### Pydantic
Valida los datos entrantes automáticamente. Si falta un campo o viene con
tipo incorrecto, rechaza la petición sin que escribas ninguna validación manual.

```python
class IrisInput(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float
```

### Endpoint /predict
```python
@app.post("/predict")
def predict(data: IrisInput):
    # data es el objeto Pydantic construido automáticamente del JSON entrante
    datos_array = np.array([[data.sepal_length, data.sepal_width,
                              data.petal_length, data.petal_width]])
    model = joblib.load(MODEL_PATH)
    prediccion = model.predict(datos_array)
    clases = load_iris().target_names
    return {"prediccion": clases[prediccion[0]]}
```

`@app.post("/predict")` es un decorador — le dice a FastAPI: "cuando llegue
una petición HTTP POST a la ruta /predict, ejecuta la función de abajo".

### Cómo arrancar la API
```bash
uvicorn api.main:app --reload
```
`--reload` reinicia el servidor automáticamente al cambiar el código.
Solo para desarrollo, en producción no se usa.

### Hacer una predicción
```bash
curl -X POST http://127.0.0.1:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```
Respuesta: `{"prediccion": "setosa"}`

---

## Paso 3 — Docker

Sin Docker: "en mi máquina funciona" es un problema real.
Con Docker: la máquina va dentro de la caja. Funciona igual en tu portátil,
en el servidor, en la nube.

### Imagen vs Contenedor
- **Imagen** → plantilla autosuficiente con Python, dependencias, código y modelo.
  Como una clase en Python. Se crea con `docker build`. No ejecuta nada.
- **Contenedor** → instancia en ejecución de la imagen.
  Como un objeto en Python. Se crea con `docker run`.
- Un Dockerfile, una imagen, infinitos contenedores en paralelo.
- En producción se corren varios contenedores de la misma imagen
  para repartir el tráfico entre ellos.

### El Dockerfile explicado línea a línea

```dockerfile
FROM python:3.12-slim
```
Imagen base — sistema operativo mínimo con Python 3.12.
`slim` = versión ligera sin herramientas innecesarias.

```dockerfile
WORKDIR /app
```
Crea la carpeta `/app` dentro del contenedor y se posiciona ahí.
Todo lo que viene después ocurre dentro de `/app`.

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
```
Copia el requirements PRIMERO y luego instala.
El orden importa: Docker cachea cada paso. Si no cambias el requirements,
no reinstala las dependencias en builds posteriores — mucho más rápido.
El código cambia frecuentemente, las dependencias no.

```dockerfile
COPY . .
```
Copia todo el proyecto al contenedor. Va después del pip install
para aprovechar la caché.

```dockerfile
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```
El comando que se ejecuta cuando arranca el contenedor con `docker run`.
NO se ejecuta durante el `docker build` — solo al arrancar la instancia.
`--host 0.0.0.0` es crítico — sin esto uvicorn solo escucha dentro
del contenedor y no puedes acceder desde fuera.

### Comandos Docker

```bash
# Construir la imagen
docker build -t iris-classifier .

# Arrancar un contenedor
docker run -p 8000:8000 iris-classifier

# Arrancar en segundo plano (producción)
docker run -d -p 8000:8000 iris-classifier

# Ver contenedores corriendo
docker ps

# Parar un contenedor (no lo borra)
docker stop <nombre_contenedor>

# Borrar un contenedor
docker rm <nombre_contenedor>
```

`-p 8000:8000` mapea el puerto 8000 de la máquina al puerto 8000 del contenedor
donde escucha uvicorn. Sin esto no puedes acceder a la API desde fuera.

---

## Paso 4 — Docker Hub

Docker Hub es un registro público — un almacén en la nube donde guardar
y distribuir imágenes. Como GitHub pero para imágenes Docker.

```bash
# Etiquetar la imagen con tu usuario para identificar destino
docker tag iris-classifier salmagserr/iris-classifier

# Subir la imagen a Docker Hub
docker push salmagserr/iris-classifier

# Cualquier máquina del mundo puede descargarla
docker pull salmagserr/iris-classifier
```

El tag no es una copia — es un alias que apunta a la misma imagen.
Mismo IMAGE ID, dos nombres.

---

## Paso 5 — Despliegue en AWS EC2

EC2 es el servicio de máquinas virtuales de AWS. Una instancia EC2 es
un ordenador con Ubuntu corriendo en un datacenter de Amazon con IP pública.

### Configuración de la instancia
- **AMI**: Ubuntu Server 26.04 LTS (free tier)
- **Tipo**: t3.micro (free tier)
- **Par de claves**: `.pem` para conectarse via SSH
- **Puerto 22**: SSH — para conectarse al servidor
- **Puerto 8000**: abierto para que el tráfico llegue al contenedor

El puerto 8000 hay que abrirlo explícitamente porque por defecto
todas las puertas están cerradas. Sin él, uvicorn escucharía dentro
del servidor pero nadie llegaría desde fuera.

### Flujo de conexión
```
Internet → puerto 8000 de la máquina AWS
               ↓
         -p 8000:8000 (mapeo Docker)
               ↓
         puerto 8000 del contenedor (uvicorn)
               ↓
         FastAPI → predice → devuelve JSON
```

### Conectarse al servidor
```bash
chmod 400 ~/Descargas/iris-classifier-key.pem  # permisos correctos al .pem
ssh -i ~/Descargas/iris-classifier-key.pem ubuntu@xx.xx
```

Una vez dentro el prompt cambia a `ubuntu@ip-:~$` —
estás en la máquina de Estocolmo, no en la tuya.

### Desplegar en el servidor
```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo docker pull salmagserr/iris-classifier   # descarga desde Docker Hub
sudo docker run -d -p 8000:8000 salmagserr/iris-classifier
```

Se usa `sudo` porque en esta máquina no se añadió el usuario al grupo docker.

### Hacer una predicción desde cualquier sitio
```bash
curl -X POST http://xx.xx:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```

Desde Windows PowerShell:
```powershell
Invoke-RestMethod -Method Post -Uri "http://xx.xx:8000/predict" `
  -ContentType "application/json" `
  -Body '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```

### Gestión de la instancia
- **Detener** — pausa la instancia, deja de gastar créditos. El contenedor
  y la imagen siguen en el disco. Al reiniciar solo hay que hacer `docker run`.
- **Terminar** — borra la instancia definitivamente.
- Al detener y reiniciar la IP pública xx.xx cambia. En producción se usa
  una **IP elástica** para que siempre sea la misma.

---

## Paso 6 — Monitoring de Drift

Cuando entrenas un modelo, lo entrenas con datos de un momento concreto.
Con el tiempo los datos reales que llegan a la API pueden ser diferentes
a los datos de entrenamiento — el modelo empieza a predecir mal sin dar error.

### Tipos de drift
- **Data drift** — la distribución de los datos de entrada cambia
- **Concept drift** — la relación input→output cambia

En producción se monitoriza primero data drift porque se puede detectar
sin etiquetas reales. Si se detecta, se investiga si hay concept drift.

### Por qué comparamos producción vs entrenamiento
El entrenamiento es la referencia — lo que el modelo conoce.
Comparar producción vs producción no tiene ancla: no sabes si alguno
de los dos se parece a lo que el modelo vio durante el entrenamiento.

### monitor.py con Evidently
```python
from evidently import Report
from evidently.presets import DataDriftPreset

report = Report([DataDriftPreset()])
my_eval = report.run(df_produccion, df_entrenamiento)  # actual, referencia
my_eval.save_html("drift_report.html")
```

El reporte usa el test de Kolmogorov-Smirnov (K-S) por columna.
Si el p_value < 0.05 hay drift en esa columna.
Si más del 50% de columnas tienen drift, se considera drift global.

```bash
python -m src.monitor
xdg-open drift_report.html
```

---

## Lo que faltaría en producción real

- **GitHub Actions** — automatiza el build, push y despliegue con cada `git push`.
  Sin tocar nada: `git push` → `docker build` → `docker push` → SSH → `docker run`
- **Kubernetes** — orquesta múltiples contenedores, escala automáticamente,
  reinicia contenedores caídos. Tú le dices cuántas réplicas y él gestiona todo.
- **IP elástica** — IP pública fija que no cambia al reiniciar la instancia
- **Autenticación** — API keys o tokens para controlar quién puede usar la API
- **MLflow** — registro de experimentos, versiones de modelos y métricas

### GitHub Actions + Kubernetes juntos
```
git push
   ↓
GitHub Actions → docker build + docker push a Docker Hub
   ↓
GitHub Actions avisa a Kubernetes: "hay imagen nueva"
   ↓
Kubernetes descarga y actualiza los contenedores sin interrumpir el servicio
```

GitHub Actions gestiona el build y la entrega.
Kubernetes gestiona el despliegue y la disponibilidad.
Son complementarios, no alternativos.