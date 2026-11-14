# TA-IND-01 · Análisis Crítico de un Sistema Distribuido Real: MinIO frente a Apache HDFS

| | |
|---|---|
| **Universidad** | Universidad Técnica Estatal de Quevedo (UTEQ) |
| **Facultad** | Facultad de Ciencias de la Ingeniería (FCI) |
| **Carrera** | Ingeniería de Software / Computación |
| **Asignatura** | Sistemas Distribuidos · Unidad 1 (Semana 3) |
| **Tarea** | `TA-IND-01` · Informe Académico Individual |
| **Tema** | MinIO Distribuido con Erasure Coding (comparado con Apache HDFS) |
| **Autor** | Heiner Ariel Zambrano Ronquillo |
| **Usuario GitHub** | `Heiner-ZZZ` |
| **Host / Prompt** | `[Heiner@HP] (gh:Heiner-ZZZ)` |

---

## 1. Resumen Ejecutivo

El presente informe académico y laboratorio experimental analiza **MinIO en modo distribuido**, una plataforma moderna de almacenamiento de objetos de alto rendimiento compatible con AWS S3 API, contrastándola de forma crítica con el sistema de archivos tradicional **Apache HDFS**. El análisis fundamenta su discusión teórica y empírica en los conceptos de la Unidad 1:

- **Transparencias de distribución:** Evaluación exhaustiva de las ocho transparencias (acceso, ubicación, migración, reubicación, replicación, concurrencia, fallos y rendimiento). Se demuestra empíricamente que MinIO ofrece transparencia total de acceso, ubicación, replicación y concurrencia a nivel de almacenamiento; sin embargo, la **transparencia de fallos en el extremo del cliente es parcial** y depende indispensablemente de un balanceador de carga perimetral (L4/L7) o DNS dinámico para evitar errores de conexión al caer un nodo.
- **Teorema CAP y extensión PACELC:** MinIO opera como un sistema estrictamente **CP y PC/EC**: ante particiones de red ($P$), prioriza la consistencia estricta ($C$) sobre la disponibilidad ($A$) exigiendo quórum de mayoría simple ($Q_w \ge (N/2) + 1$); en operación normal sin particiones ($E$), garantiza consistencia inmediata *read-after-write* ($C$) sobre la latencia ($L$) mediante verificación distribuida síncrona de metadatos `xl.meta` vía RPC.
- **Topología Simétrica *Shared-Nothing* vs. Jerarquía Maestro-Esclavo:** A diferencia de HDFS, que centraliza la administración del espacio de nombres en la memoria RAM del *NameNode* (generando un cuello de botella estructural y el problema de archivos pequeños), MinIO implementa una arquitectura simétrica sin nodo maestro donde cada instancia ejecuta el mismo binario en Go y cualquier nodo puede asumir el rol de coordinador efímero para atender solicitudes S3.
- **Tolerancia a fallos mediante Reed-Solomon (*Erasure Coding*):** MinIO prescinde de la replicación triplicada ($3\times$) de HDFS (que impone 200% de sobrecosto espacial). Mediante el algoritmo de codificación de borrado Reed-Solomon con factor $K=2, M=2$ (`EC:2`), el clúster tolera la pérdida simultánea de hasta 2 nodos en lectura (50% de la infraestructura) con únicamente 100% de sobrecarga (reduciéndose hasta 33% en clústeres de 16 nodos), garantizando protección contra corrupción silenciosa (*bitrot*) y auto-recuperación continua (*self-healing*).
- **Desacoplamiento de Cómputo y Almacenamiento:** Siguiendo la evaluación comparativa de Malhotra et al. (2025), se evidencia que la co-ubicación de cómputo y datos en HDFS ocasiona un desperdicio masivo de recursos de procesamiento al escalar capacidad, mientras que MinIO desacopla ambas capas optimizando el costo en infraestructuras de nube.
- **Experimento propio y verificación empírica:** Despliegue de un clúster contenedorizado de 4 nodos MinIO con imágenes endurecidas (*distroless* Chainguard), ingesta de datos, inyección controlada de fallos con detención de contenedores, comprobación de caída de resolución en cliente estático, conmutación exitosa a nodo par (*failover*), lectura en modo degradado y cicatrización automática (*healing*) en 21 segundos.

---

## 2. Estructura del Repositorio

```text
TA-IND-01-Heiner Ariel Zambrano Ronquillo/
├── AGENTS.md                             # Protocolo de integridad académica y alcance técnico
├── BITACORA.md                           # Registro de sesiones de trabajo, problemas, soluciones y tiempos
├── README.md                             # Documentación global del repositorio y guía de reproducción
├── Referencias/                          # Artículos científicos consultados (PDFs indexados Open Access)
│   ├── Analyzing the Performance of the S3 Object Storage API for HPC Workloads.pdf
│   ├── Cache-Based Matrix Technology for Efficient Write and Recovery in Erasure Coding Distributed File Systems.pdf
│   ├── Evaluating Fault Tolerance and Scalability in Distributed File Systems A Case Study of GFS, HDFS, and MinIO.pdf
│   ├── Improving Remote File Access in Distributed Object Stores by Decoupling Metadata and Data Paths using NVMe-oF.pdf
│   ├── Optimizing Object Storage Performance for Large File Uploading under Small-start Environments.pdf
│   ├── Performance Analysis of Storage Systems in Edge Computing Infrastructures.pdf
│   └── TrafficProfiling and Secure Virtualized Data Handling of 5G Networks via.pdf
├── capturas/                             # Evidencias fotográficas con identidad verificada
│   ├── 01_despligue_de_nodos.png         # Exp. Fase 1: 4 nodos Up About an hour (prompt verificado)
│   ├── 02_Configuración del cliente mc.png# Exp. Fase 2: Configuración del alias localminio
│   ├── 03_ topología Erasure Coding.png  # Exp. Fase 2: Topología Network 4/4 OK y paridad EC:2
│   ├── 04_Creación del bucket distribuido.png # Exp. Fase 3: Creación de bucket datos-distribuidos
│   ├── 05_Subida_objeto_erasure_coding.png # Exp. Fase 3: Carga de objeto y dispersión Reed-Solomon
│   ├── 06_Verificacion_objeto_en_bucket.png# Exp. Fase 3: mc ls validando consistencia fuerte
│   ├── 07_Estado_cluster_Docker_Desktop.png# Exp. Fase 1: Docker Desktop (259.43 MB RAM total)
│   ├── 08_Inyeccion_fallo_detencion_minio1.png # Exp. Fase 4: docker stop minio1 (inyección de fallo)
│   ├── 09_Estado_cluster_con_fallo_minio1.png # Exp. Fase 4: Docker Desktop con minio1 detenido
│   ├── 10_Fallo_resolucion_nodo1_apagado.png  # Exp. Fase 4: Fallo de red DNS en cliente estático
│   ├── 11_Acceso_nodo2_cluster_degradado.png  # Exp. Fase 5: Conmutación a minio2 y quórum activo
│   ├── 12_Lectura_objeto_en_cluster_degradado.png # Exp. Fase 5: Lectura íntegra en modo degradado
│   ├── 13_Recuperacion_healing_nodo1.png # Exp. Fase 6: Reintegración y healing en 21 segundos
│   ├── anexo_b_01_malhotra2025_p7_erasure_coding.png # Anexo B: Malhotra et al. (2025), Pág. 7
│   ├── anexo_b_02_malhotra2025_p8_hdfs_vs_minio.png  # Anexo B: Malhotra et al. (2025), Pág. 8
│   ├── anexo_b_03_han2025_p3_metadata_rpc.png        # Anexo B: Han et al. (2025), Pág. 3
│   ├── anexo_b_04_shin2023_p2_erasure_coding_hdfs.png# Anexo B: Shin & Kim (2023), Pág. 2
│   └── anexo_b_05_makris2022_p6_minio_rendimiento_ram.png # Anexo B: Makris et al. (2022), Pág. 6
├── experimento/                          # Scripts y configuración del entorno distribuido
│   ├── docker-compose.yml                # Configuración del clúster de 4 nodos (Chainguard hardened)
│   ├── comando_prueba.md                 # Guía paso a paso de comandos de laboratorio y pruebas
│   ├── resultado_experimento.txt         # Consolidación estructurada de salidas de terminal
│   └── preparar_prompt_captura.sh        # Utilidad para estandarizar variables de prompt
├── figura/                               # Diagramas arquitectónicos
│   ├── bosquejo_inicial_amano.jpeg       # Bosquejo inicial dibujado a mano alzada (Anexo A)
│   ├── Captura de pantalla 2026-11-13 225541.png # Constancia de edición en lienzo Draw.io
│   ├── diagrama_MINIO.drawio.xml         # Archivo vectorial editable del diagrama formal
│   └── MINIO.drawio.png                  # Diagrama formal de arquitectura exportado (Figura 1)
└── informe/                              # Código fuente y compilación del informe académico
    ├── main.tex                          # Documento maestro en LaTeX (13 secciones obligatorias)
    ├── main.pdf                          # Informe final compilado (26 páginas, 0 errores sintácticos)
    └── referencias.bib                   # Base bibliográfica IEEE con DOIs verificados (BibLaTeX)
```

---

## 3. Índice de Evidencias y Recursos Gráficos

| Recurso | Descripción técnica y conceptual | Enlace al archivo |
|---|---|---|
| **Diagrama Formal de Arquitectura** | Malla simétrica de 4 nodos MinIO, topología contenerizada, dispersión de fragmentos $D_1, D_2, P_1, P_2$ ($EC:2$) vía RPC y ruta de *failover* del cliente hacia `minio2`. Figura 1 del informe. | [Ver archivo](figura/MINIO.drawio.png) |
| **Diagrama Editable (Draw.io)** | Archivo XML vectorial original con el diseño del diagrama formal de arquitectura. | [Ver archivo](figura/diagrama_MINIO.drawio.xml) |
| **Captura de Edición en Draw.io** | Registro del espacio de trabajo del estudiante durante el modelado de la arquitectura en Draw.io. | [Ver archivo](figura/Captura%20de%20pantalla%202026-11-13%20225541.png) |
| **Bosquejo Manuscrito Inicial** | Fotografía del primer diseño conceptual elaborado a mano alzada en papel cuadriculado por el estudiante con fecha 12/11/2026 (Anexo A). | [Ver archivo](figura/bosquejo_inicial_amano.jpeg) |
| **Evidencia 1 (Fase 1)** | `docker compose ps`: Los 4 nodos activos y estables (*Up About an hour* a las 23:19:05). | [Ver archivo](capturas/01_despligue_de_nodos.png) |
| **Evidencia 2 (Fase 1)** | Docker Desktop: Panel de supervisión confirmando consumo ultra ligero de memoria RAM (259.43 MB combinada) y 0.68% de CPU. | [Ver archivo](capturas/07_Estado_cluster_Docker_Desktop.png) |
| **Evidencia 3 (Fase 2)** | `mc alias set`: Configuración exitosa del alias `localminio` hacia `minio1:9000` con persistencia de credenciales. | [Ver archivo](capturas/02_Configuración%20del%20cliente%20mc.png) |
| **Evidencia 4 (Fase 2)** | `mc admin info`: Auditoría de topología confirmando conectividad `Network: 4/4 OK`, 4 discos activos y esquema `EC:2`. | [Ver archivo](capturas/03_%20topología%20Erasure%20Coding.png) |
| **Evidencia 5 (Fase 3)** | `mc mb`: Creación del bucket distribuido `datos-distribuidos` atendida por el coordinador inicial. | [Ver archivo](capturas/04_Creación%20del%20bucket%20distribuido.png) |
| **Evidencia 6 (Fase 3)** | `mc cp`: Subida y fraccionamiento del archivo `comando_prueba.md` (5.64 KiB) con cálculo continuo de paridad Reed-Solomon. | [Ver archivo](capturas/05_Subida_objeto_erasure_coding.png) |
| **Evidencia 7 (Fase 3)** | `mc ls`: Comprobación inmediata del objeto persistido con metadatos `xl.meta`, validando consistencia fuerte *read-after-write*. | [Ver archivo](capturas/06_Verificacion_objeto_en_bucket.png) |
| **Evidencia 8 (Fase 4)** | `docker stop minio1`: Inyección controlada de falla mediante detención abrupta del nodo coordinador. | [Ver archivo](capturas/08_Inyeccion_fallo_detencion_minio1.png) |
| **Evidencia 9 (Fase 4)** | Docker Desktop: Actualización de estado reflejando `minio1` detenido y reducción del consumo de RAM a 194.39 MB. | [Ver archivo](capturas/09_Estado_cluster_con_fallo_minio1.png) |
| **Evidencia 10 (Fase 4)** | `mc admin info`: Error crítico `dial tcp: lookup minio1: no such host`. Demuestra que la transparencia de fallos no es automática en clientes estáticos sin balanceador L4/L7. | [Ver archivo](capturas/10_Fallo_resolucion_nodo1_apagado.png) |
| **Evidencia 11 (Fase 5)** | Conmutación (*failover*) a `minio2:9000`: Consulta administrativa exitosa confirmando quórum mayoritario en modo degradado (3 discos en línea, 1 offline). | [Ver archivo](capturas/11_Acceso_nodo2_cluster_degradado.png) |
| **Evidencia 12 (Fase 5)** | `mc ls` en degradado: Lectura íntegra del archivo sin pérdida de información gracias a la reconstrucción matricial de paridad Reed-Solomon. | [Ver archivo](capturas/12_Lectura_objeto_en_cluster_degradado.png) |
| **Evidencia 13 (Fase 6)** | `docker start minio1`: Reintegración del nodo en 21 segundos (`Uptime: 21 seconds`), restableciendo la malla 4/4 OK y autorrecuperación (*healing*) en segundo plano. | [Ver archivo](capturas/13_Recuperacion_healing_nodo1.png) |
| **Lectura Crítica 1** | Malhotra et al. (2025), p. 7: Reed-Solomon, tolerancia de caída de hasta 50% de nodos y autorrecuperación (*Self-Healing*) (Anexo B). | [Ver archivo](capturas/anexo_b_01_malhotra2025_p7_erasure_coding.png) |
| **Lectura Crítica 2** | Malhotra et al. (2025), p. 8: Sobrecosto 3x de HDFS (10 PB $\rightarrow$ 30 PB, 300 nodos) vs. separación de recursos en MinIO (Anexo B). | [Ver archivo](capturas/anexo_b_02_malhotra2025_p8_hdfs_vs_minio.png) |
| **Lectura Crítica 3** | Han et al. (2025), p. 3: Desacoplamiento de planos de datos y metadatos `xl.meta` vía llamadas RPC síncronas (Anexo B). | [Ver archivo](capturas/anexo_b_03_han2025_p3_metadata_rpc.png) |
| **Lectura Crítica 4** | Shin & Kim (2023), p. 2: Eficiencia de almacenamiento de Erasure Coding frente a replicación en bloque (Anexo B). | [Ver archivo](capturas/anexo_b_04_shin2023_p2_erasure_coding_hdfs.png) |
| **Lectura Crítica 5** | Makris et al. (2022), p. 6: Mínimo consumo de RAM (<300 MB) y alto rendimiento transaccional de MinIO (Anexo B). | [Ver archivo](capturas/anexo_b_05_makris2022_p6_minio_rendimiento_ram.png) |
| **Guía de Laboratorio** | Guía detallada con comandos exactos de PowerShell/Bash, parámetros de Docker y escenarios de prueba. | [Ver archivo](experimento/comando_prueba.md) |
| **Salidas de Terminal** | Registro textual estructurado con las salidas reales obtenidas durante la sesión experimental. | [Ver archivo](experimento/resultado_experimento.txt) |

---

## 4. Video de Sustentación (3–5 Minutos)

> ### ▶ [Ver Video de Sustentación en YouTube (No Listado) / Google Drive](https://youtu.be/PENDIENTE_ENLACE_VIDEO)
> *(Reemplace este enlace con la URL definitiva de su video antes del cierre de la entrega).*

### Aspectos Demostrados en el Video:
1. **Justificación de la Selección de MinIO:** Explicación técnica de la superioridad del modelo de almacenamiento de objetos frente a Apache HDFS, destacando la eliminación del cuello de botella centralizado del *NameNode* y el ahorro de espacio mediante *Erasure Coding*.
2. **Topología Simétrica y Consumo de Recursos:** Demostración en vivo en PowerShell (`[Heiner@HP] (gh:Heiner-ZZZ)`) del clúster de 4 nodos en Docker Desktop consumiendo apenas 259 MB de RAM conjunta, y verificación de paridad `EC:2` con `mc admin info`.
3. **Inyección de Falla y Límites de la Transparencia de Red:** Detención intencionada de `minio1` (`docker stop minio1`) y comprobación del error de conexión en cliente estático (`no such host`), fundamentando por qué la transparencia de fallos en el cliente requiere balanceadores de carga L4/L7.
4. **Conmutación (*Failover*) y Quórum Degradado:** Reconfiguración del cliente hacia el nodo par `minio2:9000`, demostrando que el clúster retiene mayoría estricta ($3/4 \ge 3$) y descarga el archivo intacto mediante la reconstrucción matricial de Reed-Solomon.
5. **Auto-Cicatrización (*Self-Healing*):** Reactivación de `minio1` y reintegración automática en 21 segundos (`Uptime: 21 seconds`) a la malla simétrica 4/4 OK sin intervención manual ni reinicio de servicios.

---

## 5. Guía Rápida de Compilación y Reproducción

### 5.1 Compilación del Informe Académico (LaTeX)

El documento principal [informe/main.tex](informe/main.tex) utiliza la distribución TeX Live o MiKTeX con el motor **Biber** para la gestión bibliográfica IEEE. Para compilar el informe y generar el documento de 26 páginas [informe/main.pdf](informe/main.pdf):

```bash
# 1. Ingresar al directorio del informe
cd informe

# 2. Primera pasada de compilación
pdflatex -interaction=nonstopmode main.tex

# 3. Procesar la base de datos bibliográfica IEEE
biber main

# 4. Segunda pasada de compilación para enlaces y citas
pdflatex -interaction=nonstopmode main.tex

# 5. Pasada final para asentar referencias cruzadas y numeración de figuras
pdflatex -interaction=nonstopmode main.tex
```

> **Nota para Overleaf:** Si compila en la nube, suba los archivos de `informe/`, la carpeta `figura/` y `capturas/`, asegurándose de seleccionar **biber** como motor de bibliografía en la configuración del proyecto.

---

### 5.2 Reproducción del Experimento Distribuido (Docker)

El laboratorio experimental requiere Docker Desktop en Windows, macOS o Linux:

```powershell
# 1. Ingresar a la carpeta del experimento
cd experimento

# 2. Desplegar los 4 nodos MinIO en segundo plano
docker compose up -d minio1 minio2 minio3 minio4

# 3. Verificar estado saludable de los contenedores
docker compose ps

# 4. Configurar el alias del cliente mc hacia el nodo minio1
docker compose run --rm mc alias set localminio http://minio1:9000 minioadmin minioadmin123

# 5. Inspeccionar la topología y verificar paridad EC:2
docker compose run --rm mc admin info localminio

# 6. Crear el bucket distribuido y cargar un objeto de prueba
docker compose run --rm mc mb localminio/datos-distribuidos
docker compose run --rm -v ${PWD}:/work mc cp /work/comando_prueba.md localminio/datos-distribuidos/
docker compose run --rm mc ls localminio/datos-distribuidos/


La guía completa y las interpretaciones conceptuales detalladas de cada fase están documentadas en [`experimento/comando_prueba.md`](experimento/comando_prueba.md) y [`experimento/resultado_experimento.txt`](experimento/resultado_experimento.txt).
