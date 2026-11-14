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

---

## Sesión 2 — Viernes, 13 de noviembre de 2026
- **Tiempo dedicado:** 3 horas y 30 minutos (00:15 – 00:45 y 15:00 – 18:00)
- **Actividades realizadas:**
  - Elaboración del bosquejo inicial a mano de la arquitectura distribuida de ClickHouse (Cliente SQL, Nodo Coordinador, Shards MergeTree y ClickHouse Keeper con consenso Raft), firmado y fechado para el Anexo A (`img/esquema_mano.jpg`).
  - Lectura crítica, subrayado y anotación en Mendeley de tres artículos científicos indexados: Han et al. (2024, p. 3745), Blinowski et al. (2022, p. 20357) y Habib et al. (2024, p. 194631), guardando sus evidencias en `img/`.
  - Documentación textual de las salidas de consola y tiempos de ejecución en `resultados_experimento.txt` para respaldar la reproducibilidad del experimento en Docker.
  - Diseño y exportación en draw.io del diagrama arquitectónico digital (`arquitectura_clickhouse.png` y respaldo fuente `.drawio`) incorporando puertos internos (`:9000`, `:8123`, `:9009`, `:9181`), compresión LZ4/ZSTD y leyenda de flujos síncronos/asíncronos.
- **Problemas encontrados:**
  - En los artículos de doble columna en inglés de IEEE Access y PVLDB fue necesario localizar los fragmentos específicos sobre consenso de bitácoras WAL, comunicación en red y consistencia de datos manteniendo visible el número de página impreso en la captura.
- **Solución aplicada:**
  - Se encuadraron las capturas mostrando tanto el texto subrayado y comentado como el pie de página editorial de cada revista, y se verificaron todos los identificadores DOI para enlazarlos en el Anexo B de `main.tex`.

---

## Sesión 3 — Viernes, 13 de noviembre de 2026 (Bloque Nocturno)
- **Tiempo dedicado:** 3 horas y 45 minutos (20:00 – 23:45)
- **Actividades realizadas:**
  - Actualización de identificadores DOI verificados y metadatos IEEE en `referencias.bib` junto con el desarrollo completo de las secciones y rutas de figuras en `main.tex`.
  - Corrección de etiquetas de protocolos, puertos internos y leyenda de flujos síncronos/asíncronos en `Arquitectura_clickhouse.drawio` y `Arquitectura_clickhouse.png`.
  - Sincronización de las métricas exactas de ejecución (`0,403 s` en inserción de 1 000 000 de filas, `8,00 MB` procesados, `0,030 s` en agregación analítica y `11,97 MiB` de RAM) entre `resultados_experimento.txt` y `main.tex`.
  - Grabación del video de sustentación individual (3–5 minutos), publicación en YouTube en modo Oculto y registro del enlace (`https://youtu.be/R_zr359o9fU`) junto con el orden de compilación LaTeX en `README.md`.
  - Compilación en Overleaf (`pdflatex` + `biber`) y subida de la versión final `main.pdf` (15 páginas) con bibliografía IEEE `[1]`–`[6]` y anexos.
- **Problemas encontrados:**
  - Las rutas relativas de la carpeta `img/` y las métricas del experimento debían coincidir exactamente con las capturas de consola y el archivo `.bib` para compilar sin advertencias en Overleaf.
- **Solución aplicada:**
  - Se validaron todas las rutas gráficas en `main.tex`, se ajustaron los valores numéricos de la Sección 4 y Conclusiones contra las capturas reales y se verificó el PDF compilado de 15 páginas.
