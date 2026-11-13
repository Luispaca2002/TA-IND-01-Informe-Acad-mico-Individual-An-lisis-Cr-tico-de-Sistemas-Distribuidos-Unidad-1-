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
* **23:55 - 23:59 | Documentación y Estandarización de Identidad:**
  * Redacción y subida de `README.md` estructurando la descripción general del proyecto, el árbol del repositorio y las instrucciones de compilación.
  * Creación del script `experimento/preparar_prompt_captura.sh` para la estandarización del prompt en sesiones Bash.

### 2. Problemas Encontrados y Soluciones Aplicadas
* **Duda conceptual sobre el modelo de comunicación interna:**
  * *Problema:* Confusión inicial sobre si MinIO repartía los bloques entre nodos de forma secuencial en cadena (estilo replicación en tubería / *pipelining* de HDFS) o de forma simultánea.
  * *Solución:* Se aclaró que MinIO utiliza una arquitectura simétrica (*Shared-Nothing*) donde el nodo receptor calcula la matriz Reed-Solomon y dispara las escrituras RPC a todos los nodos en paralelo, plasmando este comportamiento en el dibujo.
* **Permisos de volúmenes persistentes para usuario no-root:**
  * *Problema:* Las imágenes de Chainguard operan por seguridad bajo el UID 65532, lo que podía causar bloqueos de permisos de escritura sobre los montajes de volumen local `./data`.
  * *Solución:* Se automatizó el servicio `init-permissions` con BusyBox para ejecutar `chown -R 65532:65532` y `chmod -R 775` antes del encendido de los nodos.

### 3. Tiempo Dedicado
* **Duración:** 2 horas y 30 minutos.

---

## Sesión 2: Viernes, 13 de noviembre de 2026

### 1. Actividades Realizadas y Cronología de la Sesión
* **00:10 - 00:13 | Versionado de la Infraestructura Distribuida (docker-compose.yml):**
  * Integración formal y commit (`57aaed3`) del archivo `experimento/docker-compose.yml`.
  * Definición reproducible de los 4 nodos (`minio1` a `minio4`) en la red bridge `minio-distributed-net`, puertos (9000-9003 y consolas 9010-9013), volúmenes persistentes locales y servicio cliente `mc`.
* **00:14 - 00:20 | Estructuración del Andamiaje Académico en LaTeX (informe/main.tex):**
  * Versionado y commit (`19a3aed`) de la estructura inicial de `informe/main.tex` con las 13 secciones obligatorias del informe.
  * Configuración de la carátula formal, paquetes tipográficos, soporte de idioma español (`babel`), gestión de bibliografía con BibLaTeX (estilo IEEE / Biber) y apéndices.
  * Vinculación en el **Anexo A** de la imagen digitalizada del bosquejo manual (`../figura/bosquejo_inicial_amano.jpeg`).
* **00:21 - 00:25 | Consolidación y Sincronización de Bitácora:**
  * Registro y commit (`74372a0`) de la actualización de `BITACORA.md` sincronizada con los primeros avances de la madrugada.
* **00:22:48 - 00:22:52 | Carga de Objeto Distribuido con Erasure Coding (Captura 5):**
  * A las **00:22:48** se ejecutó el intento inicial de subida:  
    `docker compose run --rm mc cp comando_prueba.md localminio/datos-distribuidos/`  
    presentando el error por aislamiento de contenedor: `mc: <ERROR> Unable to prepare URL for copying. Requested path '/comando_prueba.md' not found`.
  * A las **00:22:52** se corrigió de inmediato montando el directorio actual del host como volumen en `/work`:  
    `docker compose run --rm -v ${PWD}:/work mc cp /work/comando_prueba.md localminio/datos-distribuidos/`
  * Subida exitosa de `comando_prueba.md` (5.64 KiB a 33.25 KiB/s), dividiendo y codificando el objeto en fragmentos de datos y paridad Reed-Solomon en el clúster.
  * Registro de la quinta evidencia en `capturas/05_Subida_objeto_erasure_coding.png` mostrando el progreso al 100% y el prompt con marca temporal exacta (`[Heiner@HP] [2026-11-13 00:22:52] (gh:Heiner-ZZZ)`).
* **00:38:43 | Registro del Bosquejo de Arquitectura en Git:**
  * Commit formal (`9ac999a`) integrando `figura/bosquejo_inicial_amano.jpeg` en el repositorio para su compilación en el Anexo A del informe.
* **00:53:18 | Verificación del Objeto en el Bucket Distribuido (Captura 6):**
  * A las **00:53:18** se ejecutó la consulta de comprobación en el bucket:  
    `docker compose run --rm mc ls localminio/datos-distribuidos/`
  * Salida confirmada del clúster:  
    `[2026-11-13 05:52:25 UTC] 5.6KiB STANDARD comando_prueba.md`
  * Verificación de persistencia, metadata y consistencia del objeto distribuido en los nodos de almacenamiento.
  * Registro de la sexta evidencia en `capturas/06_Verificacion_objeto_en_bucket.png` con prompt exacto (`[Heiner@HP] [2026-11-13 00:53:18] (gh:Heiner-ZZZ)`).
* **00:54:22 | Versionado de la Guía de Comandos del Experimento:**
  * Commit formal (`aa5a2a8`) agregando `experimento/comando_prueba.md` con las instrucciones detalladas de inyección de fallos, tolerancia y recuperación.
* **00:55:24 | Monitoreo del Clúster en Docker Desktop (Captura 7):**
  * A las **00:55:24** (reloj de Windows `0:55`) se capturó el panel de gestión de Docker Desktop.
  * Verificación del stack `experimento` con los 4 contenedores MinIO activos (`minio1` a `minio4`) en sus respectivos puertos (9000-9003) y `minio-init-permissions` detenido tras ajustar permisos.
  * Métricas de consumo del clúster saludable: `259.43 MB` de RAM y `0.68%` de CPU (sobre 12 núcleos).
  * Registro de la séptima evidencia en `capturas/07_Estado_cluster_Docker_Desktop.png`.
* **01:15 - 01:21 | Incorporación Inicial de Bibliografía IEEE (Commit a47aa60):**
  * Registro y commit (`a47aa60`) de la primera referencia base en `informe/referencias.bib` (*Han et al., 2025* en *IEEE Micro*, DOI: 10.1109/MM.2025.3564477) analizando la ruta interna de MinIO (`xl.meta`, RPC y NVMe-oF).
* **01:31:16 - 01:31:29 | Inyección de Fallos: Detención de Nodo minio1 (Captura 8):**
  * A las **01:31:16** se ejecutó la inyección controlada de fallo desconectando el primer nodo de almacenamiento:  
    `docker stop minio1`
  * Salida confirmada: `minio1`.
  * Propósito experimental: comprobar el comportamiento del clúster bajo degradación de hardware y evaluar la persistencia del quórum con $3/4$ nodos activos frente a la configuración de paridad Reed-Solomon ($K=2, M=2$).
  * Registro de la octava evidencia en `capturas/08_Inyeccion_fallo_detencion_minio1.png` con prompt exacto (`[Heiner@HP] [2026-11-13 01:31:16] (gh:Heiner-ZZZ)`).
* **01:32:37 | Inspección de Estado Degradado en Docker Desktop (Captura 9):**
  * A las **01:32:37** se registró la consola de Docker Desktop evidenciando el estado del clúster tras la inyección del fallo.
  * Confirmación visual: `minio1` pasa a estado detenido (círculo gris inactivo), mientras `minio2`, `minio3` y `minio4` continúan operando normalmente (círculos verdes).
  * Descenso correlativo en el consumo de recursos a `194.39 MB` de memoria y `0.38%` de CPU, validando que el clúster sigue activo en modo resiliente.
  * Registro de la novena evidencia en `capturas/09_Estado_cluster_con_fallo_minio1.png`.
* **01:35:11 - 01:36:18 | Consulta Administrativa Fallida tras Caída de Nodo (Captura 10):**
  * A las **01:35:11** se ejecutó la consulta administrativa:  
    `docker compose run --rm mc admin info localminio`
  * A las **01:36:18** el comando retornó el error de resolución de red:  
    `mc: <ERROR> Unable to get service info. Get "http://minio1:9000/minio/admin/v3/info?metrics=false": dial tcp: lookup minio1 on 127.0.0.11:53: no such host.`
  * Comprobación empírica directa de la falta de transparencia de fallos en el cliente sin balanceador de carga: el clúster como conjunto retiene quórum en sus 3 nodos sobrevivientes, pero el cliente `mc` queda bloqueado al depender de la URL estática del nodo apagado.
  * Registro de la décima evidencia en `capturas/10_Fallo_resolucion_nodo1_apagado.png` y formalización en el commit `e8c49e4` (02:02:08).
* **02:00 - 06:25 | Investigación y Consulta Bibliográfica de Madrugada (4 Fuentes Avanzadas Pendientes de Commit):**
  * Durante el transcurso de la madrugada y hasta el amanecer (06:25 a.m.), se profundizó en la investigación y lectura crítica de literatura académica indexada para sustentar la discusión teórica de la Unidad 1 y el Anexo B.
  * Aunque la referencia inicial (*Han et al., 2025*) ya fue subida en un commit previo, las **últimas 4 referencias avanzadas** fueron consultadas, leídas y comprobadas exhaustivamente en esta franja horaria:
    1. *Shen et al. (2025)* — **ACM Transactions on Storage** (DOI: `10.1145/3708994`): Análisis profundo de la evolución de *Erasure Coding* en almacenamiento distribuido y cloud frente al esquema de replicación 3x de Hadoop.
    2. *Noor et al. (2025)* — **Future Generation Computer Systems (Elsevier)** (DOI: `10.1016/j.future.2024.107522`): Benchmarking y revisión sistemática de esquemas de codificación de borrado en almacenamiento de objetos.
    3. *Malhotra et al. (2025)* — **arXiv:2502.01981 [cs.DC]** (DOI: `10.48550/arXiv.2502.01981`): Caso de estudio comparativo directo entre GFS, HDFS y MinIO respecto a tolerancia a fallos y cuellos de botella del NameNode.
    4. *Jamal et al. (2021)* — **IEEE SACI 2021** (DOI: `10.1109/SACI51354.2021.9465594`): Comparación empírica de rendimiento y latencia entre almacenamiento de objetos S3 y sistemas de archivos distribuidos (HDFS).
  * Se verificó rigurosamente cada DOI en los portales oficiales de ACM, Elsevier, IEEE Xplore y arXiv para asegurar concordancia total con la rúbrica y prevenir calificación cero.
  * Estas 4 fuentes (junto con las de *Chung & Nakamura, 2026* y *Mehmood & Hussain, 2025*) quedaron estructuradas e integradas localmente en `informe/referencias.bib`, pendientes de commit en el repositorio para la siguiente sincronización.

### 2. Problemas Encontrados y Soluciones Aplicadas
* **Ruta de archivo no encontrada dentro del contenedor de `mc`:**
  * *Problema:* El cliente `mc` corre dentro de un contenedor Docker aislado. Al ejecutar `docker compose run --rm mc cp comando_prueba.md ...`, el contenedor no puede ver los archivos del sistema de archivos local de Windows, arrojando el error `Unable to prepare URL for copying. Requested path '/comando_prueba.md' not found`.
  * *Solución:* Se agregó el montaje de volumen en línea `-v ${PWD}:/work`, permitiendo que el contenedor acceda al archivo local mediante la ruta `/work/comando_prueba.md`.
* **Requisito estricto de fuentes indexadas con DOI verificable:**
  * *Problema:* La rúbrica penaliza con calificación cero cualquier referencia inexistente o con DOI discordante.
  * *Solución:* Se verificó cada DOI directamente en sus plataformas editoriales originales (IEEE, ACM, Elsevier, Scopus, IPSJ, arXiv), garantizando concordancia total entre autores, título, volumen, año y enlace persistente.
* **Fallo de resolución DNS en el cliente `mc` ante nodo detenido:**
  * *Problema:* Al ejecutar `mc admin info localminio`, la consulta falló con `dial tcp: lookup minio1 on 127.0.0.11:53: no such host` debido a que el DNS de Docker dio de baja inmediatamente el registro de `minio1` y el alias `localminio` apuntaba fijamente a dicho contenedor.
  * *Solución:* Se analizó el comportamiento bajo los conceptos de la Unidad 1 (Transparencia de Fallos y topología *Shared-Nothing*). Se evidenció que el clúster sigue operativo reteniendo quórum ($3/4 \ge 3$), pero el cliente carece de conmutación por error (*failover*), determinando la necesidad de reconfigurar el alias hacia un nodo par activo (`http://minio2:9000`) y justificando técnicamente el uso de balanceadores de carga L4/L7 en producción.
* **Exigencia estricta de fuentes indexadas con DOI comprobado (Riesgo de calificación cero):**
  * *Problema:* La rúbrica penaliza severamente la inclusión de fuentes no verificables o datos bibliográficos discordantes.
  * *Solución:* Durante la madrugada se validó cada artículo directamente en los portales editoriales de ACM, Elsevier, IEEE Xplore y arXiv, verificando que los identificadores DOI resuelvan exactamente a los autores, título, volumen y páginas citadas, garantizando una bibliografía libre de alucinaciones.

### 3. Tiempo Dedicado
* **Fase experimental en terminal (00:10 a 01:55):** 1 hora y 45 minutos.
* **Fase de investigación, consulta y lectura bibliográfica (02:00 a 06:25):** 2 horas y 30 minutos (tiempo efectivo dedicado a revisión de artículos y comprobación de DOIs).
* **Total acumulado Sesión 2:** 4 horas y 15 minutos.
