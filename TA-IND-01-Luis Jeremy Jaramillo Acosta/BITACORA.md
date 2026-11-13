# Bitácora de Trabajo — TA-IND-01

Registro cronológico de sesiones de investigación, experimentación local en Docker y redacción en LaTeX para el análisis crítico de ClickHouse frente a Apache Cassandra.

---

## Sesión 1 — Jueves, 12 de noviembre de 2026
- **Tiempo dedicado:** 4 horas (19:30 – 23:50)
- **Actividades realizadas:**
  - Definición del sistema distribuido principal (ClickHouse) y del sistema de contraste (Apache Cassandra) para el análisis comparativo de la Unidad 1.
  - Creación de la estructura del proyecto y del documento `main.tex` con las 13 secciones reglamentarias (carátula, resumen, introducción, arquitectura, análisis CAP/PACELC, transparencias, modelos de comunicación, tolerancia a fallos, experimentación, ejemplos del entorno, comparativa, postura crítica y conclusiones).
  - Despliegue local en Docker de dos contenedores independientes (`ch-nodo1` y `ch-nodo2`), creación de la base de datos `analitica_uteq` y ejecución del script `experimento_clickhouse.sql` con inserción de 1,000,000 de registros particionados y simulación de caída de nodo (`docker stop ch-nodo2`).
  - Recopilación y verificación de 6 fuentes académicas y técnicas (2021–2024) en Mendeley, estructurando `referencias.bib` en formato IEEE para su compilación con `biblatex` y `biber`.
- **Problemas encontrados:**
  - Al finalizar la consulta sobre `system.parts` dentro de `clickhouse-client`, el comando `exit;` generó un error de sintaxis SQL impidiendo volver a PowerShell para detener `ch-nodo2`. Asimismo, fue necesario verificar los identificadores DOI exactos de los artículos de 2024 en el gestor bibliográfico antes de enlazarlos en LaTeX.
- **Solución aplicada:**
  - Se utilizó el comando nativo `quit` (sin punto y coma) para cerrar la sesión del cliente TCP y repetir correctamente la captura de detención del nodo réplica; además, se validaron los metadatos de las 6 referencias en `referencias.bib` dejando lista la estructura documental para incorporar los anexos gráficos en la siguiente sesión.
