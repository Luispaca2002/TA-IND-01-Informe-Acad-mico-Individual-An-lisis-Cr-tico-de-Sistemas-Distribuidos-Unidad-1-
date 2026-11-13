# Bitácora de Trabajo — TA-IND-01

Registro de sesiones de investigación, experimentación local en Docker y redacción en LaTeX para el análisis crítico de ClickHouse frente a Apache Cassandra.

---

## Sesión 1 — Jueves, 12 de noviembre de 2026
- **Tiempo dedicado:** 2 horas (19:30 – 21:30)
- **Actividades realizadas:**
  - Definición del sistema distribuido principal (ClickHouse) y del sistema de contraste (Apache Cassandra).
  - Creación del repositorio público en GitHub y estructuración del documento `main.tex` con las 13 secciones reglamentarias.
  - Redacción del Resumen ejecutivo (Sección 2) y de la Introducción (Sección 3) delimitando el problema del procesamiento analítico distribuido (OLAP).
- **Problemas encontrados:**
  - Selección de un escenario experimental local en Docker que permitiera evidenciar las propiedades de particionamiento, replicación y tolerancia a fallos de ClickHouse sin saturar la memoria RAM del equipo local.
- **Solución aplicada:**
  - Se diseñó un despliegue ligero mediante contenedores Docker de `clickhouse-server` utilizando tablas particionadas e inspección de metadatos del sistema (`system.parts` y `system.clusters`) para las pruebas empíricas.
