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
