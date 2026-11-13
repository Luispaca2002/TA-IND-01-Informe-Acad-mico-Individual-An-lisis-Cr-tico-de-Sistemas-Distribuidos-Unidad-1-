# Bitácora de Trabajo y Progreso

**Proyecto:** Actividad TA-IND-01 — Informe Académico Individual: Análisis Crítico de un Sistema Distribuido Real (MinIO frente a Apache HDFS)  
**Estudiante:** Heiner Ariel Zambrano Ronquillo  
**Periodo:** Semana 3 (Jueves 12 al Viernes 13 de noviembre de 2026)  

---

## Sesión 1: Jueves, 12 de noviembre de 2026

### 1. Actividades Realizadas y Cronología de la Sesión
* **21:30 - 22:10 | Definición Temática y Análisis Arquitectónico:**
  * Elección formal de **MinIO** como sistema distribuido principal y **Apache HDFS** como sistema secundario comparativo.
  * Análisis preliminar de los componentes del sistema (cliente S3, nodo coordinador efímero, malla simétrica por RPC y almacenamiento de fragmentos de datos y paridad mediante Erasure Coding).
* **22:13 | Despliegue Inicial del Clúster en Docker:**
  * Ejecución de `docker compose up -d minio1 minio2 minio3 minio4` en la carpeta `experimento/` con imágenes Chainguard y BusyBox (`init-permissions`).
  * Los 4 contenedores quedaron levantados y operativos en segundo plano.
* **22:15 - 23:15 | Elaboración Manual del Bosquejo Arquitectónico (Anexo A):**
  * Mientras el clúster permanecía activo en segundo plano, se trabajó en papel cuadriculado dibujando a mano alzada el diagrama con nombre (*Heiner Ariel Zambrano Ronquillo*) y fecha (*12/11/2026*).
  * Se diagramó el flujo: petición S3 (`PUT/GET`), cálculo de hashing y paridad (2 datos + 2 paridad), dispersión paralela vía RPC a los nodos del clúster (`minio2`, `minio3`, `minio4`), almacenamiento en volúmenes `/data` y quórum de tolerancia a fallos.
  * Digitalización y subida de la imagen bajo `figura/bosquejo_inicial_amano.jpeg`.
* **23:16 - 23:25 | Verificación de Estabilidad y Captura de Evidencia 1:**
  * Retorno a la terminal tras finalizar el dibujo para comprobar el estado de los contenedores mediante `docker compose ps`.
  * Como evidencia de este flujo de trabajo combinado, la salida refleja el estado **`Up About an hour`** en los 4 nodos (`minio1`, `minio2`, `minio3`, `minio4`), demostrando que el clúster se mantuvo estable y en ejecución continua durante todo el tiempo en que se elaboraba el bosquejo.
  * Registro de la captura de pantalla en `capturas/01_despligue_de_nodos.png` con el prompt de identidad (`[Heiner@HP]`, marcas de tiempo de 22:13 a 23:19 y `gh:Heiner-ZZZ`).
* **23:26 - 23:30 | Configuración del Cliente MinIO (mc) y Enlace de Comunicación (Captura 2):**
  * Ejecución del comando de inicialización y vinculación del cliente oficial `mc` en `experimento/`:
    `docker compose run --rm mc alias set localminio http://minio1:9000 minioadmin minioadmin123`
  * Establecimiento del enlace de comunicación entre el contenedor efímero del cliente y el endpoint de la API S3 del nodo `minio1:9000` en la red interna `minio-distributed-net`, persistiendo la configuración y claves de acceso en el volumen `./mc-config`.
  * Registro de la segunda captura de evidencia en `capturas/02_Configuración del cliente mc.png` evidenciando la confirmación del alias (`Added 'localminio' successfully`) con el prompt de identidad activo.

### 2. Problemas Encontrados y Soluciones Aplicadas
* **Duda conceptual sobre el modelo de comunicación interna:**
  * *Problema:* Confusión inicial sobre si MinIO repartía los bloques entre nodos de forma secuencial en cadena (estilo replicación en tubería / *pipelining* de HDFS) o de forma simultánea.
  * *Solución:* Se aclaró que MinIO utiliza una arquitectura simétrica (*Shared-Nothing*) donde el nodo receptor calcula la matriz Reed-Solomon y dispara las escrituras RPC a todos los nodos en paralelo, plasmando este comportamiento en el dibujo.
* **Permisos de volúmenes persistentes para usuario no-root:**
  * *Problema:* Las imágenes de Chainguard operan por seguridad bajo el UID 65532, lo que podía causar bloqueos de permisos de escritura sobre los montajes de volumen local `./data`.
  * *Solución:* Se automatizó el servicio `init-permissions` con BusyBox para ejecutar `chown -R 65532:65532` y `chmod -R 775` antes del encendido de los nodos.

### 3. Tiempo Dedicado
* **Duración Total:** 2 horas y 30 minutos (distribuidas entre la configuración/despliegue del clúster, la elaboración del bosquejo a mano en papel, la verificación del estado y la configuración del cliente mc).

---

## Sesión 2: Viernes, 13 de noviembre de 2026

### 1. Actividades Realizadas
* 

### 2. Problemas Encontrados y Soluciones Aplicadas
* 

### 3. Tiempo Dedicado
* 
