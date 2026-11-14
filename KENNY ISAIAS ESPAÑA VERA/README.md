# TA-IND-01 · Análisis Crítico de un Sistema Distribuido Real: Apache Kafka en modo KRaft

| | |
|---|---|
| **Universidad** | Universidad Técnica Estatal de Quevedo (UTEQ) |
| **Facultad** | Facultad de Ciencias de la Ingeniería (FCI) |
| **Carrera** | Ingeniería de Software · 7.º Semestre |
| **Asignatura** | Sistemas Distribuidos · Unidad 1 |
| **Tarea** | `TA-IND-01` · Informe Académico Individual |
| **Tema** | Apache Kafka en modo KRaft (comparado con RabbitMQ) |
| **Autor** | Kenny Isaías España Vera |

---

## 1. Resumen ejecutivo

El informe analiza Apache Kafka, una plataforma de streaming basada en un log particionado y replicado, en su modo KRaft, que reemplaza a ZooKeeper por un quórum de controladores basado en Raft. El análisis aplica los conceptos de la Unidad 1:

- **Transparencias de distribución:** evaluación de las siete transparencias (acceso, ubicación, migración, reubicación, replicación, concurrencia y fallos), indicando cuáles garantiza Kafka, cuáles comparte con el cliente y cuáles delega al operador.
- **Teorema CAP y PACELC:** con `acks=all`, `min.insync.replicas=2` y la elección no limpia deshabilitada, Kafka se comporta como **PC/EC**. Una partición acepta escrituras solo si |ISR| ≥ m, y en operación normal la latencia queda acotada por la réplica más lenta del ISR.
- **Consenso KRaft y replicación ISR:** el plano de control funciona con mayoría estricta (Raft) y el plano de datos con un conjunto dinámico de réplicas sincronizadas.
- **Tolerancia a fallos:** detección por heartbeats y tiempos de sesión, y reelección automática de líder sin perder mensajes confirmados.
- **Caso real:** incidente de PagerDuty del 28 de agosto de 2025, en el que el agotamiento de la memoria heap de la JVM muestra que la replicación no protege frente a fallos correlacionados.
- **Comparativa con RabbitMQ:** tabla de seis criterios y discusión crítica de los datos empíricos publicados.
- **Experimento propio:** clúster de 3 nodos KRaft en Docker Compose, con detención controlada de un broker y observación de la reelección de líder.

---

## 2. Estructura del repositorio

```text
KENNY ISAIAS ESPAÑA VERA/
├── main.tex                          # Informe completo en LaTeX (13 secciones)
├── referencias.bib                   # 18 fuentes en formato BibLaTeX (estilo IEEE)
├── BITACORA.md                       # Registro de sesiones de trabajo, problemas y tiempos
├── README.md                         # Este documento
├── figuras/
│   ├── esquema_mano.jpeg             # Bosquejo de arquitectura dibujado a mano (Anexo A)
│   └── arquitectura_kafka.drawio.xml # Archivo editable del diagrama en draw.io
├── evidencias/
│   ├── arquitectura_kafka.drawio.png # Diagrama de arquitectura final (Figura 1)
│   ├── 01_nodos_activos.png          # Experimento: 3 contenedores activos
│   ├── 02_creacion_topic.png         # Experimento: creación del topic
│   ├── 03_estado_isr_normal.png      # Experimento: Isr 1,2,3
│   ├── 04_fallo_timeout_nodo1.png    # Experimento: falla del cliente tras detener kafka-1
│   ├── 05_reeleccion_isr_2_3.png     # Experimento: reelección de líder e Isr 2,3
│   └── lectura_1.png … lectura_4.png # Evidencias de lectura y subrayado (Anexo B)
└── experimento/
    ├── docker-compose.yml            # Clúster Kafka KRaft de 3 nodos
    ├── comandos_prueba.md            # Guía de comandos paso a paso
    └── resultados_experimento.txt    # Registro de salidas de terminal
```

> **PDF final:** el informe se compila en Overleaf y todavía no hay un `main.pdf` en esta carpeta. Cuando se agregue, quedará junto a `main.tex`.

---

## 3. Índice de evidencias y recursos gráficos

| Recurso | Descripción técnica | Enlace |
|---|---|---|
| Diagrama de arquitectura | Arquitectura de Kafka en modo KRaft: quórum de 3 controladores (plano de control), brokers con particiones líder y seguidoras (plano de datos) y consumo pull por offsets. Figura 1 del informe. | [Ver archivo](evidencias/arquitectura_kafka.drawio.png) |
| Diagrama editable | Fuente del diagrama anterior en formato draw.io. | [Ver archivo](figuras/arquitectura_kafka.drawio.xml) |
| Bosquejo a mano | Versión simplificada de la arquitectura, dibujada a mano (Anexo A). | [Ver archivo](figuras/esquema_mano.jpeg) |
| Evidencia 1 | `docker ps`: contenedores `kafka-1`, `kafka-2` y `kafka-3` activos en los puertos 9092, 9093 y 9094. | [Ver archivo](evidencias/01_nodos_activos.png) |
| Evidencia 2 | Creación del topic `eventos-distribuidos` con 3 particiones y factor de replicación 3. | [Ver archivo](evidencias/02_creacion_topic.png) |
| Evidencia 3 | Estado normal: un líder por broker, `Isr: 1,2,3` y `min.insync.replicas=2`. | [Ver archivo](evidencias/03_estado_isr_normal.png) |
| Evidencia 4 | Tras `docker stop kafka-1`, el cliente con un solo servidor de arranque (`kafka-1:9092`) falla con `ConfigException` porque no puede resolver el nombre del nodo. | [Ver archivo](evidencias/04_fallo_timeout_nodo1.png) |
| Evidencia 5 | Consulta desde `kafka-3`: la partición 0 pasa a `Leader: 2` y el ISR se reduce a `2,3` sin intervención manual. | [Ver archivo](evidencias/05_reeleccion_isr_2_3.png) |
| Lectura 1 | Raptis y Passarella (IEEE Access, 2023), p. 4: replicación con líder y réplicas, y confirmación al productor. | [Ver archivo](evidencias/lectura_1.png) |
| Lectura 2 | Zhou et al. (Applied Sciences, 2024), p. 4: líder, seguidores y lista ISR. | [Ver archivo](evidencias/lectura_2.png) |
| Lectura 3 | Zhou et al. (Applied Sciences, 2024), p. 12: costo de la replicación y de la espera de confirmaciones. | [Ver archivo](evidencias/lectura_3.png) |
| Lectura 4 | Pacella et al. (Algorithms, 2025), p. 10: rendimiento de productores y consumidores de Kafka frente a RabbitMQ. | [Ver archivo](evidencias/lectura_4.png) |
| Guía de comandos | Comandos exactos del experimento: quórum, topic, falla y recuperación. | [Ver archivo](experimento/comandos_prueba.md) |
| Registro de ejecución | Salidas de terminal del experimento. | [Ver archivo](experimento/resultados_experimento.txt) |

---

## 4. Video de sustentación (3–5 minutos)

> ### ▶ [Ver video de sustentación en YouTube](https://youtu.be/y3S6U-sr3uI)

Lo que se demuestra en el video:

1. **Clúster KRaft de 3 nodos:** despliegue con Docker Compose de `kafka-1`, `kafka-2` y `kafka-3`, cada uno como broker y controlador, y creación del topic `eventos-distribuidos` (3 particiones, factor de replicación 3).
2. **Fallo de resolución DNS en el cliente:** al detener `kafka-1`, un cliente que solo conoce `kafka-1:9092` como servidor de arranque no puede resolver el nombre y falla antes de llegar al clúster. Muestra que la transparencia de fallos termina en el borde del cliente.
3. **Reelección automática de liderazgo:** consultando desde un nodo sobreviviente, la partición 0 pasa a `Leader: 2` y el conjunto sincronizado queda en `Isr: 2,3`. Se sigue cumpliendo `min.insync.replicas=2`, así que el topic mantiene la disponibilidad de escritura.

---

## 5. Guía rápida de compilación y reproducción

### 5.1 Compilar el informe (LaTeX)

Requiere `pdflatex` y `biber` (TeX Live o MiKTeX). Desde esta carpeta:

```bash
pdflatex main
biber main
pdflatex main
pdflatex main
```

El resultado es `main.pdf`, de 23 páginas. En Overleaf basta con subir `main.tex`, `referencias.bib` y las carpetas `figuras/` y `evidencias/`, y pulsar **Recompile**: Overleaf usa biber automáticamente.

### 5.2 Reproducir el experimento (Docker)

Requiere Docker Desktop. Cada broker está limitado a `-Xmx384M`.

```bash
# 1. Levantar el clúster de 3 nodos KRaft
cd experimento
docker compose up -d
docker compose ps

# 2. Verificar el quórum de controladores
docker exec -it kafka-1 /opt/kafka/bin/kafka-metadata-quorum.sh --bootstrap-server kafka-1:29092 describe --status

# 3. Crear el topic y ver líderes e ISR
docker exec -it kafka-1 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-1:29092 --create --topic eventos-distribuidos --partitions 3 --replication-factor 3
docker exec -it kafka-1 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-1:29092 --describe --topic eventos-distribuidos

# 4. Simular la caída de un nodo y consultar desde un sobreviviente
docker stop kafka-1
docker exec -it kafka-3 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-3:29092 --describe --topic eventos-distribuidos

# 5. Reincorporar el nodo y limpiar el entorno
docker start kafka-1
docker compose down -v
```

La guía completa, con las salidas esperadas e interpretación, está en [`experimento/comandos_prueba.md`](experimento/comandos_prueba.md).
