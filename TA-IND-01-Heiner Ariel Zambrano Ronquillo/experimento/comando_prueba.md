# Guía de Comandos y Protocolo de Pruebas del Clúster MinIO Distribuido

Este documento detalla el procedimiento técnico paso a paso para desplegar, interactuar, simular fallos y verificar la tolerancia a fallos en el clúster distribuido de **MinIO (4 nodos con Erasure Coding)** frente al cliente oficial **MinIO Client (`mc`)**.

---

## 1. Preparación del Entorno y Despliegue del Clúster

### 1.1 Configurar el Prompt para Capturas de Pantalla
Antes de ejecutar los comandos, active el script de personalización del prompt interactivo para garantizar que en cada captura aparezca su usuario, hostname, fecha, hora con segundos y usuario de GitHub:

```bash
cd experimento
source preparar_prompt_captura.sh
```

### 1.2 Iniciar los Contenedores del Clúster
Inicie los 4 nodos distribuidos en segundo plano. El servicio `init-permissions` se ejecutará primero de manera automática para asegurar que las carpetas de datos tengan los permisos UID 65532 correspondientes al usuario no privilegiado de Chainguard:

```bash
docker compose up -d minio1 minio2 minio3 minio4
```

### 1.3 Verificar el Estado de los Contenedores
Compruebe que los 4 nodos se encuentren en estado *Up*:

```bash
docker compose ps
```

---

## 2. Configuración del Cliente MinIO (`mc`) y Verificación Inicial

### 2.1 Configurar el Alias Local
Configure el cliente `mc` para conectarse a través de la red interna de Docker al nodo `minio1`:

```bash
docker compose run --rm mc alias set localminio http://minio1:9000 minioadmin minioadmin123
```

### 2.2 Inspeccionar la Topología y el Estado del Clúster
Consulte la información administrativa global para verificar que MinIO reconoce los 4 drives distribuidos en modo Erasure Coding:

```bash
docker compose run --rm mc admin info localminio
```

**Criterios de Verificación:**
- Estado de los nodos: 4/4 en línea (*online*).
- Modo de operación: Distribuido con Erasure Coding (Reed-Solomon).
- Capacidad agregada y resumen de almacenamiento.

---

## 3. Pruebas de Operación Normal: Creación y Replicación de Objetos

### 3.1 Crear un Bucket Distribuido
Cree un nuevo bucket denominado `datos-distribuidos`:

```bash
docker compose run --rm mc mb localminio/datos-distribuidos
```

### 3.2 Cargar un Objeto de Prueba
Genere un archivo de prueba local y súbalo al clúster:

```bash
echo "Prueba de consistencia y Erasure Coding en MinIO - TA-IND-01" > prueba.txt
docker compose run --rm -v ${PWD}:/work mc cp /work/prueba.txt localminio/datos-distribuidos/
```

### 3.3 Listar y Leer el Objeto
Verifique que el objeto existe y que sus metadatos se consultan correctamente:

```bash
docker compose run --rm mc ls localminio/datos-distribuidos/
docker compose run --rm mc cat localminio/datos-distribuidos/prueba.txt
```

---

## 4. Experimento de Tolerancia a Fallos: Inyección de Caídas y Quórum CAP

En un clúster de 4 discos con paridad estándar ($N=4$, $K=2, M=2$):
* **Quórum de Lectura:** Requiere al menos 2 nodos en línea ($N - M = 2$).
* **Quórum de Escritura:** Requiere estricta mayoría: $(N/2) + 1 = 3$ nodos en línea.

### 4.1 Escenario A: Caída de 1 Nodo (Tolerancia Total)
Detenga el contenedor `minio1`:

```bash
docker stop minio1
```

Configure un alias alternativo que apunte al nodo superviviente `minio2`:

```bash
docker compose run --rm mc alias set minio-fallback http://minio2:9000 minioadmin minioadmin123
```

Compruebe el estado del clúster (debe reflejar 3 nodos online y 1 offline):

```bash
docker compose run --rm mc admin info minio-fallback
```

Pruebe lectura y escritura con 3 nodos activos (ambas operaciones deben completarse con éxito):

```bash
# Lectura de objeto existente:
docker compose run --rm mc cat minio-fallback/datos-distribuidos/prueba.txt

# Escritura de un nuevo objeto:
echo "Escritura bajo degradacion N-1" > nuevo.txt
docker compose run --rm -v ${PWD}:/work mc cp /work/nuevo.txt minio-fallback/datos-distribuidos/
```

### 4.2 Escenario B: Caída de un Segundo Nodo (Pérdida de Quórum de Escritura)
Detenga el nodo `minio2` (quedan únicamente 2 nodos activos: `minio3` y `minio4`):

```bash
docker stop minio2
```

Configure el alias hacia el nodo superviviente `minio3`:

```bash
docker compose run --rm mc alias set minio-quorum http://minio3:9000 minioadmin minioadmin123
docker compose run --rm mc admin info minio-quorum
```

Ejecute la verificación de lectura (debe mantenerse disponible por paridad Reed-Solomon):

```bash
docker compose run --rm mc cat minio-quorum/datos-distribuidos/prueba.txt
```

Intente escribir un nuevo objeto con solo 2 nodos activos (debe fallar por falta de quórum de escritura, evidenciando el comportamiento CP en el teorema CAP):

```bash
echo "Intento de escritura sin quorum" > fallo.txt
docker compose run --rm -v ${PWD}:/work mc cp /work/fallo.txt minio-quorum/datos-distribuidos/
```

---

## 5. Recuperación, Reincorporación y Auto-Sanación (*Self-Healing*)

### 5.1 Reiniciar los Nodos Detenidos
Inicie nuevamente los contenedores que fueron apagados:

```bash
docker start minio1 minio2
```

Espere entre 5 y 10 segundos para la reconexión de la malla distribuida y consulte el estado administrativo:

```bash
docker compose run --rm mc admin info localminio
```

### 5.2 Inspeccionar la Sanación de Datos (Heal Status)
Verifique o dispare el escaneo de sanación de bloques en el clúster:

```bash
docker compose run --rm mc admin heal localminio
```

---

## 6. Detención y Limpieza del Laboratorio

* **Detener los nodos preservando volúmenes de datos:**
  ```bash
  docker compose stop
  ```

* **Detener y eliminar contenedores y redes:**
  ```bash
  docker compose down
  ```

* **Limpieza completa (elimina también los volúmenes locales):**
  ```bash
  docker compose down -v
  ```
