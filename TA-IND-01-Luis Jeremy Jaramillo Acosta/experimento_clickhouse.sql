--1 Levantamiento de los nodos
docker run -d --name ch-nodo1 -p 8123:8123 -p 9000:9000 clickhouse/clickhouse-server
docker run -d --name ch-nodo2 -p 8124:8123 -p 9001:9000 clickhouse/clickhouse-server
whoami; hostname; get-date; docker ps


--2 creación de la base de datos
select hostName(), now(), version();

create database if not exists analitica_uteq;

create table if not exists analitica_uteq.eventos_red (
    id_evento UInt64,
    origen String,
    latencia_ms Float64,
    fecha DateTime
) engine = MergeTree()
partition by toYYYYMM(fecha)
order by (origen, id_evento);

--3 Ejecuta el experimento (1 millón de filas) 

insert into analitica_uteq.eventos_red
select
    number as id_evento,
    if(number % 2 = 0, 'nodo-valencia', 'nodo-quevedo') as origen,
    (number % 150) * 1.25 as latencia_ms,
    now() - (number % 86400) as fecha
from numbers(1000000);

select
    origen,
    count() as total_eventos,
    round(avg(latencia_ms), 2) as promedio_ms,
    max(latencia_ms) as pico_ms
from analitica_uteq.eventos_red
group by origen;


--4 Fallo de nodo
select partition, name, rows, bytes_on_disk, active
from system.parts
where database = 'analitica_uteq' and table = 'eventos_red';

exit;

whoami; get-date
docker stop ch-nodo2
docker ps -a --filter "name=ch-nodo"