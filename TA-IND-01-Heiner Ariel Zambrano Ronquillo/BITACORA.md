# Bitácora de Trabajo y Progreso

**Proyecto:** Actividad TA-IND-01 — Informe Académico Individual: Análisis Crítico de un Sistema Distribuido Real (MinIO frente a Apache HDFS)  
**Estudiante:** Heiner Ariel Zambrano Ronquillo  
**Periodo:** Semana 3 (Jueves 12 al Viernes 13 de noviembre de 2026)  

---

## Sesión 1: Jueves, 12 de noviembre de 2026

### 1. Actividades Realizadas
* **Definición Temática:** Elección formal de **MinIO** como sistema distribuido principal y **Apache HDFS** como sistema secundario comparativo.
* **Diseño Conceptual de la Arquitectura:** Análisis preliminar de los componentes del sistema (cliente S3, nodo coordinador efímero, malla simétrica por RPC y almacenamiento de fragmentos de datos y paridad mediante Erasure Coding).
* **Elaboración del Bosquejo Arquitectónico Inicial (Anexo A):**
  * Dibujo manual a mano alzada en papel cuadriculado con nombre completo (*Heiner Ariel Zambrano Ronquillo*) y fecha (*12/11/2026*).
  * Diagramación del flujo: petición S3 (`PUT/GET`), cálculo de hashing y paridad (2 datos + 2 paridad), dispersión paralela vía RPC a los nodos del clúster (`minio2`, `minio3`, `minio4`), almacenamiento en volúmenes `/data` y quórum de tolerancia a fallos.
  * Digitalización y subida de la imagen al repositorio bajo la ruta `figura/bosquejo_inicial_amano.jpeg`.

### 2. Problemas Encontrados y Soluciones Aplicadas
* **Duda conceptual sobre el modelo de comunicación interna:**
  * *Problema:* Confusión inicial sobre si MinIO repartía los bloques entre nodos de forma secuencial en cadena (estilo replicación en tubería / *pipelining* de HDFS) o de forma simultánea.
  * *Solución:* Se aclaró que MinIO utiliza una arquitectura simétrica (*Shared-Nothing*) donde el nodo receptor calcula la matriz Reed-Solomon y dispara las escrituras RPC a todos los nodos en paralelo, plasmando este comportamiento en el dibujo.

### 3. Tiempo Dedicado
* **Duración:** 1 hora y 30 minutos.

---

## Sesión 2: Viernes, 13 de noviembre de 2026

### 1. Actividades Realizadas
* 

### 2. Problemas Encontrados y Soluciones Aplicadas
* 

### 3. Tiempo Dedicado
* 
