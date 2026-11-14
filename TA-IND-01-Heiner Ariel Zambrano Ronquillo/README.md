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

Este trabajo presenta un análisis crítico y experimental de **MinIO en modo distribuido** frente a **Apache HDFS**, evaluado bajo los conceptos de la Unidad 1:

- **Transparencias de Distribución:** MinIO garantiza transparencia total de acceso, ubicación, replicación y concurrencia en almacenamiento. La **transparencia de fallos en el cliente es parcial**, requiriendo un balanceador perimetral (L4/L7) para evitar fallos de conexión ante caídas de nodos.
- **Teorema CAP y PACELC:** Clasificado como **CP y PC/EC**. Prioriza la consistencia estricta mediante quórum mayoritario ($Q_w \ge (N/2) + 1$) y confirmación síncrona de metadatos `xl.meta` vía RPC antes de retornar éxito al cliente.
- **Arquitectura Simétrica (*Shared-Nothing*):** Prescinde de nodos maestros. Elimina el cuello de botella en RAM del *NameNode* de HDFS y el problema de gestión de millones de archivos pequeños (*small files problem*).
- **Tolerancia a Fallos y Reed-Solomon:** Con factor $K=2, M=2$ (`EC:2`), tolera la caída del 50% de los nodos en lectura con solo 100% de sobrecarga espacial (frente al 200% de la replicación 3x de HDFS), integrando detección de *bitrot* y auto-recuperación (*healing*).
- **Desacoplamiento de Recursos:** Separa almacenamiento de cómputo, evitando el sobreaprovisionamiento masivo de hardware que impone la co-ubicación de datos en HDFS.
- **Validación Experimental:** Despliegue reproducible en Docker de 4 nodos, inyección de fallos con detención de contenedor, quórum degradado, lectura íntegra con paridad y auto-cicatrización en 21 segundos.

---

## 2. Estructura del Repositorio

```text
TA-IND-01-Heiner Ariel Zambrano Ronquillo/
├── AGENTS.md                             # Protocolo de integridad académica y alcance técnico
├── BITACORA.md                           # Bitácora cronológica de sesiones, problemas y tiempos
├── GUIA_DE_TAREA.txt                     # Directrices, rúbrica oficial y especificaciones de la tarea
├── README.md                             # Documentación global del repositorio y guía de reproducción
├── Referencias/                          # 7 artículos científicos indexados Open Access (PDFs)
├── capturas/                             # 13 evidencias de terminal y 5 lecturas críticas del Anexo B
│   ├── 01_despligue_de_nodos.png … 13_Recuperacion_healing_nodo1.png
│   └── anexo_b_01_malhotra2025_p7_erasure_coding.png … anexo_b_05_makris2022_p6_minio_rendimiento_ram.png
├── experimento/                          # Laboratorio reproducible contenerizado
│   ├── docker-compose.yml                # Clúster MinIO de 4 nodos (imágenes Chainguard hardened)
│   ├── comando_prueba.md                 # Protocolo detallado de comandos de prueba
│   ├── resultado_experimento.txt         # Salidas reales extraídas de la terminal
│   └── preparar_prompt_captura.sh        # Configuración de variables de prompt con identidad
├── figura/                               # Diagramas de arquitectura
│   ├── bosquejo_inicial_amano.jpeg       # Bosquejo manuscrito inicial en papel (Anexo A)
│   ├── Captura de pantalla 2026-11-13 225541.png # Constancia de edición en Draw.io
│   ├── diagrama_MINIO.drawio.xml         # Archivo vectorial editable en Draw.io
│   └── MINIO.drawio.png                  # Diagrama formal de arquitectura exportado (Figura 1)
└── informe/                              # Código fuente LaTeX y compilación
    ├── main.tex                          # Informe académico formal (13 secciones obligatorias)
    ├── main.pdf                          # Documento compilado de 26 páginas (0 errores)
    └── referencias.bib                   # Bibliografía IEEE procesada con Biber
```

---

## 3. Índice de Evidencias y Recursos Gráficos

| Recurso | Descripción técnica | Enlace |
|---|---|---|
| **Diagrama Formal** | Malla simétrica de 4 nodos MinIO, dispersión Reed-Solomon ($EC:2$) y conmutación (*failover*) a `minio2` (Figura 1). | [Ver archivo](figura/MINIO.drawio.png) |
| **Diagrama Editable** | Archivo fuente vectorial en formato Draw.io XML. | [Ver archivo](figura/diagrama_MINIO.drawio.xml) |
| **Captura en Draw.io** | Espacio de trabajo durante el modelado del diagrama formal. | [Ver archivo](figura/Captura%20de%20pantalla%202026-11-13%20225541.png) |
| **Bosquejo a Mano** | Fotografía del esquema inicial manuscrito por el estudiante (Anexo A). | [Ver archivo](figura/bosquejo_inicial_amano.jpeg) |
| **Evidencia 1** | `docker compose ps`: 4 nodos activos y estables (*Up About an hour* a las 23:19:05). | [Ver archivo](capturas/01_despligue_de_nodos.png) |
| **Evidencia 2** | Docker Desktop: Consumo ligero de memoria RAM conjunta (259.43 MB) y 0.68% de CPU. | [Ver archivo](capturas/07_Estado_cluster_Docker_Desktop.png) |
| **Evidencia 3** | `mc alias set`: Configuración del alias administrativo `localminio` hacia `minio1:9000`. | [Ver archivo](capturas/02_Configuración%20del%20cliente%20mc.png) |
| **Evidencia 4** | `mc admin info`: Topología con conectividad `Network: 4/4 OK`, 4 discos y paridad `EC:2`. | [Ver archivo](capturas/03_%20topología%20Erasure%20Coding.png) |
| **Evidencia 5** | `mc mb`: Creación exitosa del bucket distribuido `datos-distribuidos`. | [Ver archivo](capturas/04_Creación%20del%20bucket%20distribuido.png) |
| **Evidencia 6** | `mc cp`: Carga y fraccionamiento del objeto de prueba con Reed-Solomon. | [Ver archivo](capturas/05_Subida_objeto_erasure_coding.png) |
| **Evidencia 7** | `mc ls`: Comprobación inmediata del objeto persistido (consistencia *read-after-write*). | [Ver archivo](capturas/06_Verificacion_objeto_en_bucket.png) |
| **Evidencia 8** | `docker stop minio1`: Inyección de fallo mediante detención abrupta del coordinador. | [Ver archivo](capturas/08_Inyeccion_fallo_detencion_minio1.png) |
| **Evidencia 9** | Docker Desktop: Confirmación de `minio1` detenido y RAM reducida a 194.39 MB. | [Ver archivo](capturas/09_Estado_cluster_con_fallo_minio1.png) |
| **Evidencia 10** | `mc admin info`: Error `lookup minio1: no such host`, evidenciando el límite de transparencia en cliente. | [Ver archivo](capturas/10_Fallo_resolucion_nodo1_apagado.png) |
| **Evidencia 11** | Conmutación a `minio2:9000`: Consulta exitosa con quórum degradado (3 discos online, 1 offline). | [Ver archivo](capturas/11_Acceso_nodo2_cluster_degradado.png) |
| **Evidencia 12** | `mc ls` en degradado: Lectura íntegra del archivo mediante reconstrucción matricial de paridad. | [Ver archivo](capturas/12_Lectura_objeto_en_cluster_degradado.png) |
| **Evidencia 13** | `docker start minio1`: Reintegración en 21s (`Uptime: 21 seconds`) y auto-cicatrización (*healing*). | [Ver archivo](capturas/13_Recuperacion_healing_nodo1.png) |
| **Lectura Crítica 1** | Malhotra et al. (2025), p. 7: Reed-Solomon, tolerancia al 50% de fallos y *Self-Healing* (Anexo B). | [Ver archivo](capturas/anexo_b_01_malhotra2025_p7_erasure_coding.png) |
| **Lectura Crítica 2** | Malhotra et al. (2025), p. 8: Sobrecosto 3x de HDFS (10 PB $\rightarrow$ 30 PB) vs. separación en MinIO (Anexo B). | [Ver archivo](capturas/anexo_b_02_malhotra2025_p8_hdfs_vs_minio.png) |
| **Lectura Crítica 3** | Han et al. (2025), p. 3: Desacoplamiento de planos de metadatos `xl.meta` vía RPC síncronas (Anexo B). | [Ver archivo](capturas/anexo_b_03_han2025_p3_metadata_rpc.png) |
| **Lectura Crítica 4** | Shin & Kim (2023), p. 2: Eficiencia espacial de Erasure Coding frente a replicación en bloque (Anexo B). | [Ver archivo](capturas/anexo_b_04_shin2023_p2_erasure_coding_hdfs.png) |
| **Lectura Crítica 5** | Makris et al. (2022), p. 6: Huella mínima de RAM (<300 MB) y alto rendimiento transaccional (Anexo B). | [Ver archivo](capturas/anexo_b_05_makris2022_p6_minio_rendimiento_ram.png) |
| **Comandos de Prueba** | Protocolo paso a paso del laboratorio experimental. | [Ver archivo](experimento/comando_prueba.md) |
| **Salidas de Terminal** | Registro textual estructurado de las salidas reales obtenidas en la sesión. | [Ver archivo](experimento/resultado_experimento.txt) |

---

## 4. Video de Sustentación (3–5 Minutos)

> ### ▶ [Ver Video de Sustentación en YouTube](https://youtu.be/ZXuqhDjaoMU)

### Aspectos Sustentados en el Video:
1. **Motivo de Selección:** Justificación técnica de MinIO frente a Apache HDFS (arquitectura simétrica *Shared-Nothing* sin *NameNode* y ahorro de almacenamiento mediante *Erasure Coding*).
2. **Explicación de la Captura Clave (Figura 11):** Análisis de la salida `mc admin info localminio` tras la caída de `minio1`:
   - Red entre pares activa (`Network: 3/4 OK`) mediante RPC.
   - Quórum conservado en modo degradado (3 discos en línea, 1 fuera de línea).
   - Reconstrucción transparente de datos por paridad Reed-Solomon ($EC:2$).
   - Demostración de que la transparencia de fallos en el cliente requiere balanceadores L4/L7.
3. **Conclusión Principal:** Clasificación formal de MinIO como sistema **CP y PC/EC** y su superioridad en eficiencia de recursos frente al esquema tradicional de HDFS.

---

## 5. Guía Rápida de Compilación y Reproducción

### 5.1 Compilación del Informe Académico (LaTeX)

Requiere `pdflatex` y `biber` (distribución TeX Live o MiKTeX). Genera el documento de 26 páginas [informe/main.pdf](informe/main.pdf):

```bash
cd informe
pdflatex -interaction=nonstopmode main.tex
biber main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

---

### 5.2 Reproducción del Experimento Distribuido (Docker)

Requiere Docker Desktop en el equipo anfitrión:

```powershell
# 1. Desplegar el clúster de 4 nodos
cd experimento
docker compose up -d minio1 minio2 minio3 minio4
docker compose ps

# 2. Configurar cliente e inspeccionar topología (EC:2)
docker compose run --rm mc alias set localminio http://minio1:9000 minioadmin minioadmin123
docker compose run --rm mc admin info localminio

# 3. Crear bucket y subir archivo de prueba
docker compose run --rm mc mb localminio/datos-distribuidos
docker compose run --rm -v ${PWD}:/work mc cp /work/comando_prueba.md localminio/datos-distribuidos/
docker compose run --rm mc ls localminio/datos-distribuidos/

# 4. Simular caída de nodo y verificar fallo en cliente estático
docker stop minio1
docker compose run --rm mc admin info localminio

# 5. Conmutar cliente a minio2 y verificar lectura en degradado (quórum 3/4)
docker compose run --rm mc alias set localminio http://minio2:9000 minioadmin minioadmin123
docker compose run --rm mc admin info localminio
docker compose run --rm mc ls localminio/datos-distribuidos/

# 6. Reactivar nodo, comprobar healing en 21s y limpiar entorno
docker start minio1
Start-Sleep -Seconds 20
docker compose run --rm mc admin info localminio
docker compose down -v
```
