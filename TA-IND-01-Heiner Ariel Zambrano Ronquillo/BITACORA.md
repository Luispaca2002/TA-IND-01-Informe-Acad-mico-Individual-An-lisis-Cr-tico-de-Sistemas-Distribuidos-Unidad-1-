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
* **02:00 - 06:33 | Investigación, Consulta Bibliográfica e Integración de 6 Referencias (Commit 714784b):**
  * Durante la madrugada y primeras horas de la mañana, se profundizó en la investigación y lectura crítica de literatura académica indexada para sustentar la discusión teórica de la Unidad 1, el análisis comparativo (MinIO vs. HDFS) y el Anexo B.
  * Mientras que la primera referencia base (*Han et al., 2025*) fue subida en el commit `a47aa60`, en esta jornada se investigaron, leyeron y verificaron rigurosamente **6 referencias adicionales** con sus DOIs oficiales:
    1. *Chung & Nakamura (2026)* — **Journal of Information Processing (IPSJ)** (DOI: `10.2197/ipsjjip.34.86`): Carga multipart y concurrencia bajo latencia en MinIO.
    2. *Mehmood & Hussain (2025)* — **Computers, Materials & Continua (Scopus)** (DOI: `10.32604/cmc.2025.068404`): Despliegue de MinIO y cifrado AES-256 en virtualización 5G.
    3. *Shen et al. (2025)* — **ACM Transactions on Storage** (DOI: `10.1145/3708994`): Evolución de *Erasure Coding* en sistemas de almacenamiento frente a la replicación 3x de Hadoop.
    4. *Noor et al. (2025)* — **Future Generation Computer Systems (Elsevier)** (DOI: `10.1016/j.future.2024.107522`): Benchmarking sistemático de esquemas de codificación de borrado en almacenamiento de objetos.
    5. *Malhotra et al. (2025)* — **arXiv:2502.01981 [cs.DC]** (DOI: `10.48550/arXiv.2502.01981`): Caso de estudio comparativo directo GFS vs. HDFS vs. MinIO sobre fallos y metadatos del NameNode.
    6. *Jamal et al. (2021)* — **IEEE SACI 2021** (DOI: `10.1109/SACI51354.2021.9465594`): Evaluación empírica de rendimiento y latencia entre almacenamiento de objetos S3 y sistemas de archivos distribuidos (HDFS).
  * Estas 6 referencias fueron formalizadas y subidas en el commit `714784b`, consolidando la totalidad de las **7 referencias académicas verificadas** en `informe/referencias.bib`.
* **13:25 - 16:00 | Redacción y Maquetación Académica en LaTeX e Interrupción por Tormentas:**
  * Durante la tarde se trabajó de forma continua en la redacción, maquetación y estructuración formal del informe académico en LaTeX (`informe/main.tex`).
  * Desarrollo analítico de las secciones conceptuales de la Unidad 1 (Transparencias de Distribución, Teorema CAP/PACELC, Modelos de Comunicación y Tolerancia a Fallos), articulando la discusión crítica sobre la arquitectura *Shared-Nothing* de MinIO frente a Apache HDFS.
  * Ensamblaje y ordenamiento preliminar de las evidencias empíricas (Fases 1 a 6) y preparación de los bloques flotantes para las 13 capturas de pantalla registradas con prompt de identidad.
  * El trabajo se mantuvo activo en paralelo hasta aproximadamente las **16:00 horas**, momento en el cual se produjo un corte intempestivo del suministro eléctrico en la zona debido a fuertes tormentas eléctricas, provocando el apagado repentino del equipo y forzando una pausa temporal hasta la estabilización de la red.
* **16:21 - 16:24:26 | Reanudación y Conmutación de Acceso hacia Nodo Par minio2 (Captura 11):**
  * Tras reactivar el entorno y asegurar la detención de `minio1`, se aplicó la solución de conmutación reconfigurando el alias cliente hacia el nodo par en línea:  
    `docker compose run --rm mc alias set localminio http://minio2:9000 minioadmin minioadmin123`
  * A las **16:24:26** se ejecutó la consulta de diagnóstico administrativo:  
    `docker compose run --rm mc admin info localminio`
  * Salida confirmada del clúster:  
    - `minio1:9000`: Offline (`Drives: 0/1 OK`).
    - `minio2:9000`, `minio3:9000`, `minio4:9000`: Online (`Uptime: 4 minutes`, `Network: 3/4 OK`, `Drives: 1/1 OK`).
    - Resumen del conjunto de borrado: `1 node offline, 3 drives online, 1 drive offline, EC:2` (`5.6 KiB Used, 1 Bucket, 1 Object`).
  * Comprobación de que el clúster retiene quórum estricto y operatividad plena a través de cualquiera de sus nodos supervivientes.
  * Registro de la undécima evidencia en `capturas/11_Acceso_nodo2_cluster_degradado.png`.
* **16:24:36 | Comprobación de Integridad y Disponibilidad de Objetos bajo Fallo (Captura 12):**
  * A las **16:24:36** se ejecutó la consulta de contenido sobre el bucket distribuido:  
    `docker compose run --rm mc ls localminio/datos-distribuidos/`
  * Salida confirmada:  
    `[2026-11-13 05:52:25 UTC] 5.6KiB STANDARD comando_prueba.md`
  * Demostración empírica de que la lectura de objetos permanece ininterrumpida y transparente al cliente aun con un nodo caído, validando la tolerancia a fallos mediante reconstrucción por paridad Reed-Solomon ($K=2, M=2$).
  * Registro de la duodécima evidencia en `capturas/12_Lectura_objeto_en_cluster_degradado.png`.
* **16:29:11 - 16:29:35 | Auto-recuperación y Reincorporación del Nodo minio1 (Healing) (Captura 13):**
  * A las **16:29:11** se reincorporó el nodo detenido:  
    `docker start minio1`
  * A las **16:29:14** se consultó el estado del clúster con `docker compose run --rm mc admin info localminio`.
  * Salida confirmada a las **16:29:35**:  
    - `minio1:9000`: Online (`Uptime: 21 seconds`, `Network: 4/4 OK`, `Drives: 1/1 OK`).
    - Todos los 4 nodos activos en malla simétrica (`Network: 4/4 OK`).
    - Resumen global: `4 drives online, 0 drives offline, EC:2` (`5.6 KiB Used, 1 Bucket, 1 Object`).
  * Demostración empírica de sanación automática (*healing*) y reintegración transparente de nodos a la topología distribuida sin pérdida de metadatos ni de consistencia.
  * Registro de la decimotercera evidencia en `capturas/13_Recuperacion_healing_nodo1.png`.
* **17:00 - 18:00 | Lectura Crítica sin Conexión durante el Corte de Luz, Auditoría Open Access y Marcado de Anexo B:**
  * Aprovechando la interrupción del suministro eléctrico en la zona y la ausencia de energía de red, se utilizó la batería del equipo portátil para realizar con total tranquilidad y concentración la lectura crítica y el análisis metodológico de los artículos científicos disponibles en `Referencias/`.
  * Se identificaron y subrayaron directamente los párrafos clave de lectura crítica en las 5 fuentes científicas para el **Anexo B**:
    1. *Malhotra et al. (2025)* — arXiv, pág. 7 (`capturas/anexo_b_01_malhotra2025_p7_erasure_coding.png`): Fundamento de Erasure Coding Reed-Solomon en MinIO, división de bloques de datos y paridad, y autorrecuperación (*Self-Healing*).
    2. *Malhotra et al. (2025)* — arXiv, pág. 8 (`capturas/anexo_b_02_malhotra2025_p8_hdfs_vs_minio.png`): Comparativa arquitectónica: sobrecosto del 200% de almacenamiento en HDFS (3x) y cuellos de botella del NameNode centralizado frente al desacoplamiento en MinIO.
    3. *Han et al. (2025)* — IEEE Micro, pág. 3 (`capturas/anexo_b_03_han2025_p3_metadata_rpc.png`): Desacoplamiento del plano de metadatos `xl.meta` y llamadas RPC síncronas entre nodos de almacenamiento.
    4. *Shin & Kim (2023)* — Symmetry, pág. 2 (`capturas/anexo_b_04_shin2023_p2_erasure_coding_hdfs.png`): Sobrecarga computacional y latencia matricial de Reed-Solomon en HDFS vs replicación directa.
    5. *Makris et al. (2022)* — Applied Sciences, pág. 6 (`capturas/anexo_b_05_makris2022_p6_minio_rendimiento_ram.png`): Huella mínima de memoria RAM (<300 MB) y alto rendimiento transaccional de MinIO en entornos perimetrales (*edge*).
  * Asimismo, se consolidó la transición a artículos 100% Open Access (sustituyendo fuentes con barrera de pago de ACM, Elsevier e IEEE por Gadban et al., Makris et al. y Shin & Kim en MDPI), asegurando la verificación de DOIs oficiales y la disponibilidad permanente de los textos completos en el repositorio.
* **20:00 - 21:00 | Modelado y Creación del Diagrama de Arquitectura en Draw.io:**
  * Se trabajó en la herramienta Draw.io diseñando la arquitectura formal del clúster MinIO distribuido (`figura/diagrama_MINIO.drawio.xml`), pasando en limpio y perfeccionando el bosquejo preliminar dibujado a mano alzada.
  * Se modelaron los 4 nodos contenedores (`minio1` a `minio4`), la red bridge `minio-distributed-net`, el flujo de llamadas RPC síncronas entre nodos, la división de bloques de datos y paridad ($EC:2$) y la ruta de conmutación de cliente (*failover*) hacia `minio2` ante la caída del coordinador inicial.
  * Se exportó el diagrama final en formato de imagen como `figura/MINIO.drawio.png` y se guardó la captura del espacio de trabajo en Draw.io (`figura/Captura de pantalla 2026-11-13 225541.png`) como constancia del modelado gráfico.

* **21:00 - 21:50 | Estructuración del Documento de Resultados y Vinculación del Diagrama:**
  * Organización de `experimento/resultado_experimento.txt` consolidando las salidas reales obtenidas en la terminal de PowerShell en las distintas fases del experimento (despliegue de nodos, ingesta con metadatos `xl.meta`, inyección de fallos, conmutación y auto-recuperación de nodos).
  * Inclusión del diagrama formal (`figura/MINIO.drawio.png`) en la Sección 4 de `informe/main.tex`, redactando la explicación técnica del flujo de comunicación y la topología simétrica *Shared-Nothing*.

* **22:00 - 22:30 | Integración de Evidencias en el Anexo B y Compilación Final:**
  * Inserción de las 5 páginas subrayadas de los artículos científicos analizados en el Anexo B de `informe/main.tex` mediante formato vertical legible.
  * Compilación integral del documento final en PDF (`informe/main.pdf`) con pdfLaTeX y Biber, verificando que los diagramas, capturas de terminal, evidencias de lectura y referencias queden correctamente alineados.

### 2. Problemas Encontrados y Soluciones Aplicadas
* **Ruta de archivo no encontrada dentro del contenedor de `mc`:**
  * *Problema:* El cliente `mc` corre dentro de un contenedor Docker aislado. Al ejecutar `docker compose run --rm mc cp comando_prueba.md ...`, el contenedor no puede ver los archivos del sistema de archivos local de Windows, arrojando el error `Unable to prepare URL for copying. Requested path '/comando_prueba.md' not found`.
  * *Solución:* Se agregó el montaje de volumen en línea `-v ${PWD}:/work`, permitiendo que el contenedor acceda al archivo local mediante la ruta `/work/comando_prueba.md`.
* **Fallo de resolución DNS en el cliente `mc` ante nodo detenido:**
  * *Problema:* Al ejecutar `mc admin info localminio`, la consulta falló con `dial tcp: lookup minio1 on 127.0.0.11:53: no such host` debido a que el DNS de Docker dio de baja inmediatamente el registro de `minio1` y el alias `localminio` apuntaba fijamente a dicho contenedor.
  * *Solución:* Se analizó el comportamiento bajo los conceptos de la Unidad 1 (Transparencia de Fallos y topología *Shared-Nothing*). Se evidenció que el clúster sigue operativo reteniendo quórum ($3/4 \ge 3$), pero el cliente carece de conmutación por error (*failover*), determinando la necesidad de reconfigurar el alias hacia un nodo par activo (`http://minio2:9000`) y justificando técnicamente el uso de balanceadores de carga L4/L7 en producción.
* **Exigencia estricta de fuentes indexadas con DOI comprobado (Riesgo de calificación cero):**
  * *Problema:* La rúbrica penaliza severamente la inclusión de fuentes no verificables o datos bibliográficos discordantes.
  * *Solución:* Se validó cada artículo directamente contra la API oficial de Crossref y los portales editoriales, verificando que los identificadores DOI resuelvan con exactitud absoluta a los autores, título, volumen, número y páginas citadas, garantizando una bibliografía libre de alucinaciones.
* **Barreras de pago (Paywalls) en fuentes bibliográficas para el Anexo B:**
  * *Problema:* La rúbrica exige en el Anexo B al menos 3 capturas de pantalla de los artículos citados con párrafos subrayados por el estudiante y número de página. Las fuentes iniciales de ACM, Elsevier e IEEE requerían pago por artículo o suscripción institucional inaccesible.
  * *Solución:* Se sustituyeron por artículos científicos indexados en Scopus/SCIE de acceso abierto irrestricto (Open Access CC BY 4.0) con enlaces de descarga directa de PDF, facilitando la lectura crítica y la extracción de evidencias requeridas.
* **Corte intempestivo de fluido eléctrico por tormentas y lectura sin luz:**
  * *Problema:* A las 16:00 horas se suscitó una interrupción imprevista del suministro eléctrico provocada por fuertes tormentas en la zona, provocando el apagado repentino del equipo de escritorio y suspendiendo la sesión de redacción.
  * *Solución:* Tras estabilizar la estación y completar la prueba de conmutación, la persistencia de cortes hacia las 17:00 horas se aprovechó de forma constructiva: con el equipo portátil operando a batería y sin luz de red, se realizó con total tranquilidad y concentración la lectura crítica, análisis comparativo y selección de fragmentos subrayados de los artículos científicos para el Anexo B.

### 3. Tiempo Dedicado
* **Fase experimental en terminal de madrugada (00:10 a 01:55):** 1 hora y 45 minutos.
* **Fase de investigación, consulta y lectura bibliográfica inicial (02:00 a 06:33):** 2 horas y 30 minutos.
* **Fase de redacción y estructuración académica en LaTeX (13:25 a 16:00):** 2 horas y 35 minutos.
* **Fase experimental vespertina de tolerancia a fallos y auto-recuperación (16:20 a 16:32):** 20 minutos.
* **Fase de lectura crítica durante el corte de luz, auditoría Open Access y marcado de Anexo B (17:00 a 18:00):** 1 hora.
* **Fase de modelado del diagrama de arquitectura en Draw.io (20:00 a 21:00):** 1 hora.
* **Fase de estructuración de resultados y vinculación en informe (21:00 a 21:50):** 50 minutos.
* **Fase de integración de evidencias en Anexo B y compilación final (22:00 a 22:30):** 30 minutos.
* **Total acumulado Sesión 2:** 10 horas y 30 minutos.
