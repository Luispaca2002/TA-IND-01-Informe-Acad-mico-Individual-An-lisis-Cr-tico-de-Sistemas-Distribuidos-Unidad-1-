# TA-IND-01 — Análisis Crítico Comparativo de ClickHouse frente a Apache Cassandra

- **Universidad:** Universidad Técnica Estatal de Quevedo (UTEQ)
- **Facultad / Carrera:** Facultad de Ciencias de la Ingeniería — Ingeniería en Software
- **Asignatura:** Aplicaciones Distribuidas (Unidad 1) — Paralelo A
- **Estudiante:** Luis Jeremy Jaramillo Acosta
- **Código de Actividad:** TA-IND-01

---

## Video de Sustentación Individual

- **Enlace al video (YouTube No listado):** https://youtu.be/R_zr359o9fU

---

## Estructura de Archivos de la Carpeta

- `main.tex`: Código fuente completo del informe académico en LaTeX (13 secciones + Anexos A y B).
- `main.pdf`: Documento final compilado en formato PDF.
- `referencias.bib`: Base bibliográfica con 6 fuentes verificadas (2021–2024) en estilo IEEE.
- `Arquitectura_clickhouse.png` / `Arquitectura_clickhouse.drawio`: Diagrama digital de arquitectura y su archivo fuente editable.
- `experimento_clickhouse.sql`: Comandos Docker y consultas SQL ejecutadas en el entorno local.
- `resultados_experimento.txt`: Salidas de consola y métricas obtenidas durante la experimentación.
- `BITACORA.md`: Registro cronológico de sesiones de trabajo, problemas resueltos y tiempos dedicados.
- `img/`: Capturas de ejecución en Docker (`cap1` a `cap4`), bosquejo inicial a mano (`esquema_mano.jpeg`) y evidencias de lectura subrayadas (`lectura_fuente 1.jpeg` a `3.jpeg`).

---

## Instrucciones de Compilación y Dependencias (LaTeX)

- **Compilador y gestor bibliográfico:** `pdflatex` (TeX Live 2024 o superior / Overleaf) y `biber` (estilo IEEE).
- **Archivo principal:** `main.tex`
- **Dependencias (paquetes LaTeX requeridos):**
  - Codificación e idioma: `inputenc` (`utf8`), `fontenc` (`T1`), `babel` (`spanish,es-tabla`), `csquotes`
  - Tipografía y márgenes: `geometry` (2.5 cm), `newtxtext`, `newtxmath`
  - Maquetación, tablas y figuras: `parskip`, `ragged2e`, `enumitem`, `booktabs`, `array`, `graphicx`, `placeins`, `hyperref`
  - Bibliografía IEEE: `biblatex` (`backend=biber,style=ieee,sorting=none`)
- **Orden exacto de comandos de compilación:**

```bash
pdflatex main.tex
biber main
pdflatex main.tex
pdflatex main.tex
