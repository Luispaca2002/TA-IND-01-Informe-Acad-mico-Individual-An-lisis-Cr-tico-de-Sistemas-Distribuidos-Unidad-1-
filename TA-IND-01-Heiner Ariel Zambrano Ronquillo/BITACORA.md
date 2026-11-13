# Bitácora de Trabajo y Progreso

**Proyecto:** Actividad TA-IND-01 — Informe Académico Individual: Análisis Crítico de un Sistema Distribuido Real (MinIO frente a Apache HDFS)  
**Estudiante:** Heiner Ariel Zambrano Ronquillo  
**Periodo:** Semana 3 (Jueves 12 al Viernes 13 de noviembre de 2026)  

---

## Sesión 1: Jueves, 12 de noviembre de 2026

### 1. Actividades Realizadas y Cronología Exacta de la Sesión
* **21:30 - 22:10 | Definición Temática y Análisis Arquitectónico:**
  * Elección formal de **MinIO** como sistema distribuido principal y **Apache HDFS** como sistema secundario comparativo.
  * Análisis preliminar de los componentes del sistema (cliente S3, nodo coordinador efímero, malla simétrica por RPC y almacenamiento de fragmentos de datos y paridad mediante Erasure Coding).
* **22:13:15 | Despliegue Inicial del Clúster en Docker:**
  * Ejecución del comando de levantamiento en `experimento/`:
    `docker compose up -d minio1 minio2 minio3 minio4`
  * Descarga e inicialización de imágenes Chainguard (`minio:latest`) y BusyBox (`init-permissions`).
  * Los 4 contenedores quedaron levantados y operativos en segundo plano.
* **22:16:48 - 23:19:05 | Verificación de Estado y Elaboración del Bosquejo a Mano (Captura 1):**
  * Verificación preliminar de los contenedores a las **22:16:48** mediante `docker compose ps`.
  * Durante la hora siguiente (aprox. 22:17 a 23:15), mientras el clúster permanecía en ejecución continua en segundo plano, se trabajó en papel cuadriculado dibujando a mano alzada el diagrama arquitectónico con nombre (*Heiner Ariel Zambrano Ronquillo*) y fecha (*12/11/2026*).
  * Digitalización y subida de la imagen bajo `figura/bosquejo_inicial_amano.jpeg`.
  * Retorno a la terminal a las **23:19:05** para registrar la primera evidencia en `capturas/01_despligue_de_nodos.png`. En la salida de `docker compose ps` se aprecia fielmente el estado **`Up About an hour`** en los 4 nodos (`minio1`, `minio2`, `minio3`, `minio4`), demostrando la estabilidad del clúster durante el tiempo dedicado al dibujo.
* **23:25:43 | Configuración del Cliente MinIO (mc) y Enlace de Comunicación (Captura 2):**
  * A las **23:25:43** se ejecutó el comando de vinculación del cliente oficial `mc` en `experimento/`:
    `docker compose run --rm mc alias set localminio http://minio1:9000 minioadmin minioadmin123`
  * Descarga de la imagen cliente `cgr.dev/chainguard/minio-client:latest` y persistencia de credenciales en `/tmp/mc/config.json`.
  * Registro de la segunda captura en `capturas/02_Configuración del cliente mc.png` (reloj de Windows visible: 23:27) con la confirmación de configuración del alias.
* **23:25:52 | Inspección de la Topología Distribuida y Erasure Coding (Captura 3):**
  * A las **23:25:52** (9 segundos después de configurar el alias) se ejecutó la consulta administrativa:
    `docker compose run --rm mc admin info localminio`
  * Verificación del estado de salud del sistema distribuido: confirmación de 4/4 nodos en línea con `Uptime: 1 hour`, `Network: 4/4 OK`, `Drives: 1/1 OK` por nodo, y resumen global de **`4 drives online, 0 drives offline, EC:2`** (conjunto simétrico de Erasure Coding con 2 bloques de paridad Reed-Solomon).
  * Registro de la tercera evidencia en `capturas/03_ topología Erasure Coding.png` con la salida completa del comando y el prompt de identidad activo.
* **23:34:45 | Creación del Bucket Distribuido (Captura 4):**
  * A las **23:34:45** se ejecutó el comando de aprovisionamiento de almacenamiento de objetos:
    `docker compose run --rm mc mb localminio/datos-distribuidos`
  * Creación exitosa del bucket `datos-distribuidos` en el clúster (`Bucket created successfully 'localminio/datos-distribuidos'.`), verificando la propagación coordinada de metadatos en el clúster distribuido.
  * Registro de la cuarta evidencia en `capturas/04_Creación del bucket distribuido.png` mostrando la confirmación y el prompt de identidad con hora exacta (`[Heiner@HP] [2026-11-12 23:34:49] (gh:Heiner-ZZZ)`).

### 2. Problemas Encontrados y Soluciones Aplicadas
* **Duda conceptual sobre el modelo de comunicación interna:**
  * *Problema:* Confusión inicial sobre si MinIO repartía los bloques entre nodos de forma secuencial en cadena (estilo replicación en tubería / *pipelining* de HDFS) o de forma simultánea.
  * *Solución:* Se aclaró que MinIO utiliza una arquitectura simétrica (*Shared-Nothing*) donde el nodo receptor calcula la matriz Reed-Solomon y dispara las escrituras RPC a todos los nodos en paralelo, plasmando este comportamiento en el dibujo.
* **Permisos de volúmenes persistentes para usuario no-root:**
  * *Problema:* Las imágenes de Chainguard operan por seguridad bajo el UID 65532, lo que podía causar bloqueos de permisos de escritura sobre los montajes de volumen local `./data`.
  * *Solución:* Se automatizó el servicio `init-permissions` con BusyBox para ejecutar `chown -R 65532:65532` y `chmod -R 775` antes del encendido de los nodos.

### 3. Tiempo Dedicado
* **Duración Total:** 2 horas y 20 minutos (comprendidas entre las 21:30 y las 23:50, distribuidas entre el análisis, el despliegue del clúster, la elaboración del bosquejo físico y la toma de evidencias de terminal).

---

## Sesión 2: Viernes, 13 de noviembre de 2026

### 1. Actividades Realizadas
* 

### 2. Problemas Encontrados y Soluciones Aplicadas
* 

### 3. Tiempo Dedicado
* 
