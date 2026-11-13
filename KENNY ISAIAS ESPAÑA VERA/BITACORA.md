# Bitácora de Trabajo y Progreso

**Proyecto:** Análisis Crítico de Sistemas Distribuidos (TA-IND-01)  
**Estudiante:** Kenny Isaías España Vera  
**Sistema Principal:** Apache Kafka (Modo KRaft)  
**Sistema Secundario / Comparativo:** RabbitMQ  

---

## Sesión 1: 2026-11-12

### 1. Actividades Realizadas
- **Definición Temática y Arquitectónica:** Selección formal de **Apache Kafka** como sistema distribuido principal para el análisis crítico, estableciendo a **RabbitMQ** como contraparte comparativa para contrastar modelos de distribución (Log-centric distribuido vs. Broker de colas con AMQP).
- **Revisión de Literatura Científica:** Búsqueda y recopilación de literatura académica y técnica con identificadores de objeto digital (DOI) verificables sobre consenso distribuido, particionamiento, quórum KRaft (KIP-500) y semánticas de entrega en arquitecturas orientadas a eventos.
- **Diseño y Despliegue de Infraestructura Local:** Formulación del archivo `docker-compose.yml` para levantar un clúster de 3 nodos (`kafka-1`, `kafka-2`, `kafka-3`) operando bajo el protocolo de consenso KRaft (sin ZooKeeper), implementando listeners separados para comunicación interna inter-broker (`29092`), canales de controladores de quórum (`29093`) y exposición externa hacia el host (`localhost:9092, 9093, 9094`).
- **Experimentación Práctica Inicial:**
  - Validación de salud del quórum de metadatos KRaft (`kafka-metadata-quorum.sh`).
  - Creación del topic particionado y replicado `eventos-distribuidos` (factor de replicación 3, 3 particiones).
  - Inspección del estado de líderes y conjunto de réplicas sincronizadas (*In-Sync Replicas* - ISR).
  - Simulación de contingencia mediante la detención forzada del nodo líder (`docker stop kafka-1`), verificando la reelección transparente de líder y la contracción controlada del ISR a los nodos sobrevivientes (`Isr: 2,3`).
  - Prueba de reincorporación y sincronización (*catch-up*) tras reiniciar el broker (`docker start kafka-1`).

### 2. Problemas Encontrados y Soluciones Aplicadas
1. **Consumo Excesivo de Memoria JVM en Entorno Local:**
   - *Problema:* Por defecto, la máquina virtual de Java (JVM) de Apache Kafka reserva una porción considerable de memoria RAM por contenedor, lo que al instanciar 3 brokers simultáneos amenazaba con saturar la memoria asignada al motor de Docker Desktop.
   - *Solución:* Se definieron restricciones estrictas de asignación mediante la variable de entorno `KAFKA_HEAP_OPTS: "-Xmx384M -Xms256M"` en cada servicio del `docker-compose.yml`, asegurando estabilidad en el host y suficiente margen para las operaciones del clúster.
2. **Advertencias de Conexión Externa y `TimeoutException` al Caer el Broker Líder:**
   - *Problema:* Al detener deliberadamente `kafka-1` e intentar consultar inmediatamente el topic usando como punto de entrada (`--bootstrap-server`) la dirección de ese nodo detenido, los comandos de la CLI arrojaban errores de timeout o intentaban resolver endpoints inalcanzables.
   - *Solución:* Se ajustó la estrategia de conexión en las pruebas para apuntar a cualquiera de los brokers supervivientes (`kafka-2` o `kafka-3` tanto por la red interna como por `localhost:9093`/`localhost:9094`), demostrando empíricamente cómo los clientes distribuidos deben disponer de listas de bootstrap redundantes para tolerar caídas de nodos específicos.

### 3. Tiempo Dedicado
- **Duración:** 3 horas.

---

## Sesión 2: 2026-11-13

### 1. Actividades Realizadas
- **Diseño Arquitectónico del Clúster KRaft:** Elaboración y exportación del diagrama formal de arquitectura de Apache Kafka en modo KRaft utilizando Draw.io (`figuras/arquitectura_kafka.png` y archivo editable `figuras/arquitectura_kafka.drawio`), detallando los planos de control (controladores Raft, quórum de votantes), plano de datos (brokers, réplicas de partición, ISR) y flujos de listeners internos/externos.
- **Revisión Sistemática de Literatura Científica:** Análisis en profundidad de 6 artículos científicos indexados con identificador de objeto digital (DOI) verificable, focalizados en consenso distribuido, particionamiento de logs, consistencia y rendimiento comparativo entre sistemas de mensajería (Kafka vs. RabbitMQ).
- **Extracción de Citas Clave y Evidencias de Lectura:** Selección y catalogación de citas clave para la fundamentación del informe académico, capturando fragmentos subrayados representativos como evidencia de lectura analítica (`evidencias/lectura_1.png` a `evidencias/lectura_4.png`).

### 2. Problemas Encontrados y Soluciones Aplicadas
1. **Estandarización de Rutas y Nombres de Archivo para LaTeX:**
   - *Problema:* El uso de caracteres especiales, mayúsculas inconsistentes o espacios en los nombres de figuras genera fallas y advertencias en el motor de compilación `pdflatex` al invocar `\includegraphics`.
   - *Solución:* Se implementó una convención uniforme en minúsculas y guiones bajos (`snake_case`) limpia de caracteres especiales para todos los recursos visuales y probatorios ubicados en `figuras/` y `evidencias/`.
2. **Consistencia de Metadatos y Resolución DOI en Formato IEEE (`biblatex`):**
   - *Problema:* Inconsistencias de formato en los identificadores DOI y campos de actas/revistas al recuperar registros crudos para `biber`.
   - *Solución:* Se ejecutó una verificación manual directa contra los repositorios DOI oficiales (Crossref / IEEE Xplore) para garantizar una estructura bibliográfica precisa y validada bajo el estándar IEEE.

### 3. Tiempo Dedicado
- **Duración:** 2.5 horas.
