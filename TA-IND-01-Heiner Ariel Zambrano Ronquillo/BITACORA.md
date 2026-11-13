# Bitácora de Trabajo y Progreso

**Proyecto:** Actividad TA-IND-01 — Informe Académico Individual: Análisis Crítico de un Sistema Distribuido Real (MinIO frente a Apache HDFS)  
**Estudiante:** Heiner Ariel Zambrano Ronquillo  
**Periodo:** Semana 3 (Jueves 12 al Viernes 13 de noviembre de 2026)  

---

## Sesión 1: Jueves, 12 de noviembre de 2026

### 1. Actividades Realizadas
* **Definición Temática y Arquitectónica:** Selección formal de **MinIO** (en modo distribuido con Erasure Coding) como sistema distribuido principal para el análisis crítico, estableciendo a **Apache HDFS** como sistema secundario comparativo (arquitectura de objetos descentralizada vs. sistema de archivos basado en bloques jerárquico).
* **Diseño y Despliegue de Infraestructura Local de Laboratorio:** 
  * Configuración del archivo `experimento/docker-compose.yml` para desplegar un clúster distribuido de 4 nodos (`minio1`, `minio2`, `minio3`, `minio4`) en una red bridge dedicada (`minio-distributed-net`).
  * Implementación del servicio `init-permissions` con BusyBox para inicializar directorios y aplicar permisos `chown -R 65532:65532` sobre los volúmenes locales (`./data`), requerido por las imágenes de seguridad Chainguard que ejecutan bajo usuario no-root.
  * Configuración del servicio cliente oficial `mc` bajo perfil CLI con volumen persistente para perfiles y credenciales (`/tmp/mc`).
* **Configuración del Entorno Académico en LaTeX:**
  * Estructuración del documento principal `latex/main.tex` bajo clase `article` en español con `babel`, motor `biblatex` (estilo IEEE con backend Biber), `booktabs`, `graphicx`, `tikz` e hipervínculos.
  * Verificación sintáctica del ciclo completo de compilación (`pdflatex -> biber -> pdflatex -> pdflatex`) garantizando la generación limpia de `main.pdf`.
* **Elaboración del Bosquejo Arquitectónico Inicial (Evidencia Anexo A):**
  * Dibujo manual a mano alzada en papel cuadriculado con nombre completo y fecha (12/11/2026).
  * Diagramación de la interacción del cliente `mc` vía API S3 REST (HTTP), el rol de coordinador efímero asumido por el nodo receptor (`minio1`), la malla simétrica *Shared-Nothing*, la dispersión paralela vía RPC, y la división en 4 bloques locales (`xl.meta` + $D_1, D_2, P_1, P_2$) con cálculo de paridad Reed-Solomon y quórum de tolerancia a fallos.
  * Digitalización y respaldo de la evidencia gráfica en `figura/anexo_a_bosquejo_mano.jpg`.
* **Diseño del Protocolo Experimental:** Redacción de la guía técnica `experimento/comando_prueba.md` detallando los escenarios de prueba: levantamiento, inspección de topología, subida de objetos, inyección de fallas por caída de nodos, verificación de quórum de lectura/escritura y auto-sanación (*healing*).

### 2. Problemas Encontrados y Soluciones Aplicadas
1. **Restricción de Acceso a Imágenes Oficiales de MinIO:**
   * *Problema:* Las imágenes oficiales históricas de MinIO fueron retiradas de Docker Hub y los registros alternativos exigen credenciales privadas.
   * *Solución:* Se adoptaron las imágenes enterprise/hardened de Chainguard (`cgr.dev/chainguard/minio` y `cgr.dev/chainguard/minio-client`). Dado que estas imágenes corren estrictamente bajo UID no privilegiado `65532`, se formuló un contenedor previo `init-permissions` que asegura la propiedad de los directorios de datos antes del arranque de los nodos.
2. **Clarificación Conceptual sobre el Flujo de Dispersión de Datos:**
   * *Problema:* Existía una duda conceptual sobre si MinIO transfería los datos entre nodos de manera secuencial (similar a la replicación en tubería / *pipelining* de Apache HDFS) o en paralelo, y sobre qué componente actuaba como coordinador.
   * *Solución:* Se investigó y fundamentó la arquitectura simétrica *Shared-Nothing* de MinIO: no existe un nodo maestro fijo (a diferencia del NameNode de HDFS), sino que el nodo que recibe la petición HTTP actúa como coordinador temporal, calcula la matriz Reed-Solomon en memoria y dispersa concurrentemente las operaciones de escritura RPC a todos los nodos en paralelo. Esta comprensión técnica permitió diagramar con exactitud el bosquejo del Anexo A.

### 3. Tiempo Dedicado
* **Duración:** 3 horas y media.

---

## Sesión 2: Viernes, 13 de noviembre de 2026

### 1. Actividades Realizadas
* 

### 2. Problemas Encontrados y Soluciones Aplicadas
* 

### 3. Tiempo Dedicado
* 
