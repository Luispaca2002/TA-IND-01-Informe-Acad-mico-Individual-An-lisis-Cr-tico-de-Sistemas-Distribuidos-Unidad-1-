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

---

## Sesión 3: 2026-11-13

### 1. Actividades Realizadas
- **Estructuración y Normalización de Bibliografía Técnica (`referencias.bib`):** Consolidación de 18 fuentes bibliográficas verificadas bajo el estándar IEEE (`biblatex` con motor `biber`), integrando artículos científicos revisados por pares con identificadores DOI activos, documentación oficial de Apache Kafka 4.0 y especificación KIP-500, literatura fundamental de sistemas distribuidos (Maarten van Steen y Andrew Tanenbaum) y el reporte técnico posmórtem de PagerDuty sobre saturación de memoria heap en la JVM.
- **Redacción de la Estructura Base del Informe en LaTeX (`main.tex`):** Maquetación de la carátula institucional de la Universidad Técnica Estatal de Quevedo (UTEQ), redacción del resumen técnico y palabras clave, formulación de la introducción motivacional y desarrollo exhaustivo de la **Sección 4 (Arquitectura del sistema)**: modelo de productores con particionamiento por clave, topología de brokers y replicación, gestión y retención de segmentos de log en disco, dimensionamiento de grupos de consumidores ($C_{\text{activos}} = \min(C, P)$) y transición del esquema histórico ZooKeeper al quórum de consenso interno KRaft (KIP-500).
- **Refinamiento Arquitectónico y Diagramación Modular:** Evolución del bosquejo inicial dibujado a mano (`figuras/esquema_mano.jpeg`) hacia el diagrama vectorial formal en Draw.io (`evidencias/arquitectura_kafka.drawio.png`), disociando nítidamente el plano de control (quórum KRaft) del plano de datos (brokers y réplicas) y corrigiendo el flujo de interacción hacia un modelo pull controlado por offsets.
- **Validación de Compilación en Overleaf:** Comprobación de compilación limpia de la primera etapa del documento en la plataforma Overleaf, verificando el procesamiento de citas bibliográficas y la ausencia de advertencias tipográficas (`acks=all`, `min.insync.replicas=2`) previo al desarrollo de los conceptos de la Unidad 1.
- **Control de Versiones y Respaldo Local:** Generación de copia maestra de seguridad (`main_completo_backup.tex`) en el entorno de trabajo para garantizar la integridad del código fuente antes de iniciar la integración progresiva por fases en el repositorio Git.

### 2. Problemas Encontrados y Soluciones Aplicadas
1. **Divergencias en el Modelo de Consumo en el Esquema Inicial:**
   - *Problema:* El bosquejo inicial sugería que el broker empujaba los mensajes al consumidor (modelo push), lo cual difería del diseño real de Kafka.
   - *Solución:* Se corrigió la orientación de las interacciones tanto en el diagrama Draw.io como en la discusión de la Sección 4, explicitando el modelo pull donde el consumidor tracciona lotes según su propio ritmo y offset.
2. **Control Estricto de Parámetros de Durabilidad:**
   - *Problema:* Necesidad de evitar errores tipográficos sutiles en parámetros clave como `acks=all` (frecuentemente confundido con `a11` o `aII`) y espacios tras los puntos en `min.insync.replicas=2`.
   - *Solución:* Se auditó y normalizó el código fuente de `main.tex` y las referencias para garantizar precisión terminológica y consistencia técnica total.

### 3. Tiempo Dedicado
- **Duración:** 3 horas.

---

## Sesión 4: 2026-11-13

### 1. Actividades Realizadas
- **Desarrollo de la Sección 5 (Análisis crítico con los conceptos de la Unidad 1) en `main.tex`:** Evaluación detallada de las siete transparencias de distribución según Van Steen y Tanenbaum (acceso, ubicación, migración, reubicación, replicación, concurrencia y fallos), clasificando cada una como garantizada por Kafka, compartida con el cliente o delegada al operador, y justificando cada clasificación con el diseño del sistema (protocolo binario común, descubrimiento por metadatos, reasignación manual de particiones, reintentos del cliente ante cambio de líder, orden total por partición y reelección automática de líder).
- **Modelado Matemático y Análisis de Compromisos CAP/PACELC:** Formalización de la condición de disponibilidad de escritura de una partición ($|ISR| \ge m$), con tolerancia de $RF - m = 1$ réplica caída bajo `acks=all` y `min.insync.replicas=2`, y del costo de latencia en operación normal ($T_{\text{acks=all}} \approx T_{\text{red}} + T_{\text{anexo}} + \max_{f \in ISR} T_{\text{réplica},f}$), acotado por la réplica más lenta del ISR. Clasificación resultante del sistema como **PC/EC**, respaldada con la evidencia experimental de Zhou et al. sobre la reducción de rendimiento del productor por replicación y espera de confirmaciones, y con el quórum Raft del plano de control KRaft.
- **Caracterización de los Modelos de Comunicación:** Descripción del modelo híbrido de Kafka: cliente-servidor entre productores/consumidores y brokers sobre un protocolo binario propio en TCP, consenso entre pares (Raft) en el quórum de controladores KRaft, replicación líder-seguidor entre brokers y consumo asíncrono desacoplado con patrón pull controlado por offsets, incorporando la métrica de retraso del consumidor ($\text{lag} = \text{LEO} - \text{offset}_{\text{confirmado}}$) y las semánticas de entrega según la posición del commit.
- **Análisis de Mecanismos de Tolerancia a Fallos:** Documentación de la replicación basada en el conjunto ISR dinámico (`replica.lag.time.max.ms`), la detección de fallos por heartbeats y tiempos de sesión (`broker.session.timeout.ms` en el controlador y `session.timeout.ms` en los grupos de consumidores) y la reelección automática de líder sin pérdida de mensajes confirmados con la elección no limpia deshabilitada.
- **Contrastación Teórica con Evidencia Empírica de Producción:** Análisis del incidente real de PagerDuty (28 de agosto de 2025), en el que la creación de un productor por cada petición a la API agotó la memoria heap de la JVM en los brokers y provocó una falla en cascada, evidenciando que la replicación protege frente a fallos independientes pero no frente a fallos correlacionados que afectan por igual a todas las réplicas.

### 2. Problemas Encontrados y Soluciones Aplicadas
1. **Clasificación CAP Simplificada de Kafka:**
   - *Problema:* Kafka suele describirse como un sistema "CP" de forma absoluta, lo que ignora que su comportamiento ante particiones depende de la configuración de cada topic (`min.insync.replicas`, `unclean.leader.election.enable`) y que la durabilidad no proviene de sincronizar cada mensaje en disco (*fsync*), sino de la replicación entre brokers.
   - *Solución:* Se acotó la clasificación PC/EC a la configuración analizada (`RF=3`, `acks=all`, `min.insync.replicas=2`, elección no limpia deshabilitada) y se documentó explícitamente cómo cambiar esos parámetros desplaza el sistema hacia AP con riesgo de pérdida de datos confirmados.
2. **Inconsistencia en la Literatura sobre el Modelo de Consumo:**
   - *Problema:* Uno de los artículos revisados (Raptis y Passarella) afirma que Kafka admite consumo push y pull, lo que contradice el diseño documentado oficialmente.
   - *Solución:* Se contrastó la afirmación con la documentación oficial de Apache Kafka y se fundamentó en la Sección 5.3 el modelo exclusivamente pull, con sondeo prolongado (*long polling*) para evitar consultas vacías.

### 3. Tiempo Dedicado
- **Duración:** 0.5 horas.

---

## Sesión 5: 2026-11-13

### 1. Actividades Realizadas
- **Integración de Resultados Experimentales (Sección 6):** Incorporación de las cinco evidencias del clúster KRaft de 3 nodos (`evidencias/01_nodos_activos.png` a `evidencias/05_reeleccion_isr_2_3.png`) con su interpretación técnica: estado normal con `Isr: 1,2,3` y un líder por broker, falla del cliente al detener `kafka-1` y reelección automática de la Partición 0 hacia `Leader: 2` con `Isr: 2,3`, manteniendo la condición $|ISR| \ge m$ con `min.insync.replicas=2`.
- **Casos Prácticos del Entorno del Estudiante (Sección 7):** Redacción de los dos casos observados como usuario: saturación del SGA de la UTEQ en periodos críticos (transparencia de concurrencia, cuellos de botella centralizados y particionamiento horizontal) y demoras en transferencias de banca móvil y mensajería sin cobertura (particiones de red, consistencia eventual y almacenamiento y reenvío).
- **Cierre del Cuerpo del Informe (Secciones 8 a 13):** Redacción del análisis comparativo frente a RabbitMQ con tabla `booktabs` de seis criterios y discusión crítica de los datos de Pacella et al. y Maharjan et al., postura crítica con escenarios donde no conviene usar Kafka, cuatro conclusiones técnicas, declaración de uso de inteligencia artificial y anexos (bosquejo a mano en `figuras/esquema_mano.jpeg` y evidencias de lectura subrayadas `evidencias/lectura_1.png` a `evidencias/lectura_4.png`).
- **Verificación Final y Compilación:** Revisión del formato IEEE de las 18 referencias (`biblatex` con `biber`), correcciones tipográficas y compilación limpia del documento completo (23 páginas) sin errores ni advertencias.

### 2. Problemas Encontrados y Soluciones Aplicadas
1. **Discrepancia entre la Excepción Documentada y la Evidencia Capturada:**
   - *Problema:* El borrador describía un `TimeoutException` al detener `kafka-1`, pero la captura `04_fallo_timeout_nodo1.png` muestra `ConfigException: No resolvable bootstrap urls given in bootstrap.servers`, causada porque el DNS interno de Docker deja de resolver el nombre del contenedor detenido.
   - *Solución:* Se corrigió el análisis en el Resumen, la Sección 5.1, la Sección 6 y las Conclusiones para reflejar la excepción real, y se añadió la evidencia `05_reeleccion_isr_2_3.png`, tomada desde `kafka-3`, para separar la falla del cliente del estado real del clúster.
2. **Imagen del Anexo A no Detectada en Overleaf:**
   - *Problema:* El bosquejo se subió como `esquema_mano.jpeg` mientras que `main.tex` buscaba `esquema_mano.jpg`, por lo que el documento mostraba el recuadro de espacio reservado en lugar de la imagen.
   - *Solución:* Se unificó la extensión entre el archivo y las rutas de `\IfFileExists` e `\includegraphics`, y se ajustó el pie de figura del Anexo A.

### 3. Tiempo Dedicado
- **Duración:** 1.7 horas.
