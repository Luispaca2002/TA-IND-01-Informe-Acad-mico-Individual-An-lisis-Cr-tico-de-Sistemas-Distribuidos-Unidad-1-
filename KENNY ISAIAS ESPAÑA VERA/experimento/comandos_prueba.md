# Guía de Comandos y Pruebas del Clúster Apache Kafka (KRaft)

Este documento contiene la guía paso a paso y los comandos exactos para ejecutar y validar el experimento de tolerancia a fallos, quórum KRaft, replicación y reelección de líderes en el clúster de 3 nodos.

---

## 1. Inicio del Clúster

Desde la carpeta `experimento` en su terminal:

```bash
docker compose up -d
```

Verificar que los 3 contenedores (`kafka-1`, `kafka-2`, `kafka-3`) estén en estado *Up*:

```bash
docker compose ps
```

---

## 2. Verificación del Quórum KRaft (Sin ZooKeeper)

En el modo KRaft, el consenso del clúster se gestiona a través del protocolo Raft interno sin depender de ZooKeeper. Para comprobar que los 3 nodos están activos y forman el quórum:

### Opción A: Desde el contenedor Docker (Recomendada)
```bash
docker exec -it kafka-1 /opt/kafka/bin/kafka-metadata-quorum.sh --bootstrap-server kafka-1:29092 describe --status
```

También puede visualizar el estado de replicación del log de metadatos:
```bash
docker exec -it kafka-1 /opt/kafka/bin/kafka-metadata-quorum.sh --bootstrap-server kafka-1:29092 describe --replication
```

### Opción B: Desde su terminal local (si tiene Kafka CLI instalado)
```bash
kafka-metadata-quorum.sh --bootstrap-server localhost:9092 describe --status
```

**Salida esperada:**
- Se visualizará el `ClusterId` (`4L622nShTUiBenA3heKdgw`), el `LeaderId` del quórum de metadatos, y la lista de `Voters: [1, 2, 3]` todos activos y sincronizados.

---

## 3. Creación del Topic Replicado

Crear el topic `eventos-distribuidos` con **3 particiones** y un **factor de replicación de 3** (los datos se replicarán en todos los nodos):

### Opción A: Desde el contenedor Docker
```bash
docker exec -it kafka-1 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-1:29092 --create --topic eventos-distribuidos --partitions 3 --replication-factor 3
```

### Opción B: Desde terminal local
```bash
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic eventos-distribuidos --partitions 3 --replication-factor 3
```

**Salida esperada:**
```text
Created topic eventos-distribuidos.
```

---

## 4. Describir el Topic (Visualización de Leader, Replicas e ISR)

Visualizar la asignación inicial de líderes de partición, réplicas y conjunto de réplicas sincronizadas (*In-Sync Replicas*):

### Opción A: Desde el contenedor Docker
```bash
docker exec -it kafka-1 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-1:29092 --describe --topic eventos-distribuidos
```

### Opción B: Desde terminal local
```bash
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic eventos-distribuidos
```

**Salida esperada (ejemplo de distribución balanceada):**
```text
Topic: eventos-distribuidos	TopicId: ...	PartitionCount: 3	ReplicationFactor: 3	Configs: min.insync.replicas=2
	Topic: eventos-distribuidos	Partition: 0	Leader: 1	Replicas: 1,2,3	Isr: 1,2,3
	Topic: eventos-distribuidos	Partition: 1	Leader: 2	Replicas: 2,3,1	Isr: 2,3,1
	Topic: eventos-distribuidos	Partition: 2	Leader: 3	Replicas: 3,1,2	Isr: 3,1,2
```
*Interpretación:*
- **Leader:** Nodo encargado de atender lecturas y escrituras para esa partición.
- **Replicas:** Nodos asignados para almacenar copias de los datos.
- **ISR (In-Sync Replicas):** Nodos actualmente activos y completamente al día con el log del líder.

---

## 5. Simulación de Falla: Detención del Broker Líder (`kafka-1`)

Detener el nodo `kafka-1` para forzar un escenario de falla en el sistema distribuido:

```bash
docker stop kafka-1
```

Verificar que `kafka-1` está detenido:
```bash
docker compose ps
```

Inmediatamente describir el topic conectándose a un nodo superviviente (`kafka-2` por el puerto interno `29092` o externo `9093`):

### Opción A: Desde el contenedor sobreviviente `kafka-2`
```bash
docker exec -it kafka-2 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-2:29092 --describe --topic eventos-distribuidos
```

### Opción B: Desde terminal local (conectando a kafka-2 en puerto 9093)
```bash
kafka-topics.sh --bootstrap-server localhost:9093 --describe --topic eventos-distribuidos
```

**Salida esperada:**
```text
Topic: eventos-distribuidos	TopicId: ...	PartitionCount: 3	ReplicationFactor: 3	Configs: min.insync.replicas=2
	Topic: eventos-distribuidos	Partition: 0	Leader: 2	Replicas: 1,2,3	Isr: 2,3
	Topic: eventos-distribuidos	Partition: 1	Leader: 2	Replicas: 2,3,1	Isr: 2,3
	Topic: eventos-distribuidos	Partition: 2	Leader: 3	Replicas: 3,1,2	Isr: 3,2
```

*Análisis Crítico del Resultado:*
1. **Reelección Automática de Líder:** La partición 0 (cuyo líder era el nodo 1) fue reasignada automáticamente al nodo 2 o 3.
2. **Reducción del ISR (*Shrinking*):** El nodo 1 ya no forma parte del ISR (`Isr: 2,3`). El clúster mantiene la disponibilidad y consistencia garantizada porque se cumple `min.insync.replicas=2`.

---

## 6. Recuperación y Reincorporación del Nodo (`kafka-1`)

Reiniciar el contenedor `kafka-1` para validar la recuperación automática y resincronización de réplicas:

```bash
docker start kafka-1
```

Esperar entre 5 a 10 segundos para permitir que el broker inicie y sincronice los logs de replicación. Luego, volver a describir el topic:

### Opción A: Desde contenedor Docker
```bash
docker exec -it kafka-2 /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka-2:29092 --describe --topic eventos-distribuidos
```

### Opción B: Desde terminal local
```bash
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic eventos-distribuidos
```

**Salida esperada:**
```text
Topic: eventos-distribuidos	TopicId: ...	PartitionCount: 3	ReplicationFactor: 3	Configs: min.insync.replicas=2
	Topic: eventos-distribuidos	Partition: 0	Leader: 2	Replicas: 1,2,3	Isr: 2,3,1
	Topic: eventos-distribuidos	Partition: 1	Leader: 2	Replicas: 2,3,1	Isr: 2,3,1
	Topic: eventos-distribuidos	Partition: 2	Leader: 3	Replicas: 3,1,2	Isr: 3,2,1
```

*Análisis Crítico del Resultado:*
- **Sincronización ISR (*Catch-up*):** El nodo 1 se ha reincorporado con éxito al conjunto de réplicas sincronizadas (`Isr: 2,3,1`), restaurando la tolerancia ante una nueva falla sin intervención manual.

---

## 7. Detención y Limpieza del Entorno

Cuando finalice las pruebas:

- **Detener los contenedores conservando los datos:**
  ```bash
  docker compose stop
  ```

- **Detener y eliminar contenedores y red (preservando volúmenes):**
  ```bash
  docker compose down
  ```

- **Limpieza total (eliminar contenedores, redes y volúmenes de datos):**
  ```bash
  docker compose down -v
  ```
