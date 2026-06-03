# SQL con Docker + Azure Data Studio

## Arquitectura del setup

La idea es tener SQL Server corriendo en local sin instalarlo directamente en el sistema. Para eso se combina:

- **Docker** — levanta un contenedor con SQL Server. Es el "servidor" de base de datos.
- **Azure Data Studio** — cliente gráfico desde el que escribes y ejecutas SQL. Se conecta al contenedor.

Docker actúa como si fuera una máquina virtual ligera con SQL Server dentro. Azure Data Studio es simplemente la interfaz para interactuar con él.

> Ventajas de usar Docker: Sin instalación pesada — SQL Server en Linux/Ubuntu no es trivial de instalar. Con Docker es un docker pull y listo.
> Aislamiento — SQL Server corre en su contenedor sin tocar tu sistema. Si algo se rompe, borras el contenedor y empiezas de cero.
> Portabilidad — si mañana quieres el mismo setup en otro ordenador, es un docker pull + docker run y tienes exactamente lo mismo

---

## Instalación

### 1. Imagen de SQL Server

Se descarga la imagen oficial de Microsoft desde su registro (https://hub.docker.com/r/microsoft/mssql-server):

```bash
docker pull mcr.microsoft.com/mssql/server:2022-latest
```

Pesa aproximadamente 1.5 GB. Solo hay que hacerlo una vez; si se elimina el contenedor, la imagen sigue disponible en local.

### 2. Arrancar el contenedor

```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=tucontra" \
  -p 1433:1433 --name sqlserver -d \
  mcr.microsoft.com/mssql/server:2022-latest
```

Parámetros relevantes:

| Parámetro | Qué hace |
|---|---|
| `ACCEPT_EULA=Y` | Acepta la licencia (obligatorio) |
| `MSSQL_SA_PASSWORD` | Contraseña del usuario administrador `sa` |
| `-p 1433:1433` | Expone el puerto de SQL Server al host |
| `--name sqlserver` | Nombre del contenedor |
| `-d` | Corre en background |
| `mcr.microsoft.com/mssql/server:2022-latest` | Imagen |

La contraseña debe tener al menos 8 caracteres con mayúsculas, minúsculas, números y símbolos.

> Nota: El parámetro -p 1433:1433 sigue el formato puerto_host:puerto_contenedor — el primero es el puerto de la máquina local por donde entra el cliente (Azure Data Studio), y el segundo es el puerto interno del contenedor donde escucha SQL Server.

### 3. Conectar Azure Data Studio

Con el contenedor corriendo, se abre Azure Data Studio y se crea una nueva conexión con estos datos:

| Campo | Valor |
|---|---|
| Server | `localhost,1433` |
| Authentication | SQL Login |
| User | `sa` |
| Password | la que pusiste en `MSSQL_SA_PASSWORD` |

> Nota: La contraseña del usuario sa debe cumplir la política de SQL Server: mínimo 8 caracteres con mayúsculas, minúsculas, números y símbolos. Al conectar desde Azure Data Studio, establecer Encrypt en Optional y Trust Server Certificate en True para evitar el rechazo del certificado SSL autofirmado que genera el contenedor.

---

## Uso habitual

El contenedor no arranca solo al encender el equipo. Para gestionarlo:

```bash
# Arrancar
docker start sqlserver

# Parar
docker stop sqlserver

# Ver si está corriendo
docker ps
```

Una vez arrancado, se abre Azure Data Studio, se conecta y se trabaja normalmente con SQL.

---

## Notas

- Los datos persisten aunque el contenedor se pare — solo se pierden si se elimina el contenedor con `docker rm`.
- La edición que corre es **Developer**, gratuita para desarrollo y estudio.
- Si se elimina la imagen local, se recupera con `docker pull` sin necesidad de reconfigurar nada más.


---

## VS Code + extensión mssql

Azure Data Studio fue retirado en febrero de 2026. El sucesor directo es VS Code con la extensión **mssql** de Microsoft, que ofrece la misma funcionalidad para trabajar con SQL Server.

### Instalación

1. Instalar VS Code
2. Abrir extensiones (`Ctrl+Shift+X`), buscar `mssql` e instalar la de Microsoft

### Conexión

Con el contenedor corriendo, crear una nueva conexión desde el panel SQL Server con estos datos:

| Campo | Valor |
|---|---|
| Server name | `localhost,1433` |
| Authentication type | SQL Login |
| User name | `sa` |
| Password | la definida en `MSSQL_SA_PASSWORD` |
| Encrypt | Optional |
| Trust Server Certificate | True |

> **Nota:** La contraseña del usuario `sa` debe cumplir la política de SQL Server: mínimo 8 caracteres con mayúsculas, minúsculas, números y símbolos. Establecer **Encrypt** en `Optional` y **Trust Server Certificate** en `True` para evitar el rechazo del certificado SSL autofirmado que genera el contenedor.

### Ejecutar queries

Abrir un fichero `.sql`, asegurarse de que está conectado al servidor y ejecutar con `Ctrl+Shift+E`.