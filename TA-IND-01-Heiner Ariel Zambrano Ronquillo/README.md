# TA-IND-01: Informe Académico Individual - Análisis Crítico de Sistemas Distribuidos

* **Institución:** Universidad Técnica Estatal de Quevedo (UTEQ)  
* **Facultad:** Ciencias de la Ingeniería  
* **Asignatura:** Sistemas Distribuidos — Unidad 1 (Semana 3)  
* **Estudiante:** Heiner Ariel Zambrano Ronquillo  
* **Sistema Analizado Principal:** MinIO (Modo Distribuido con Erasure Coding)  
* **Sistema Comparativo:** Apache HDFS  

---

## 📌 Descripción del Proyecto

Este repositorio alberga el trabajo técnico, experimental y académico correspondiente a la actividad individual sumativa **TA-IND-01: Análisis Crítico de un Sistema Distribuido Real**. 

La investigación evalúa en profundidad la arquitectura interna, modelos de comunicación, transparencias de distribución, garantías de consistencia (CAP / PACELC) y mecanismos de tolerancia a fallos de **MinIO** en contraposición con el sistema de archivos tradicional **Apache HDFS**. El informe teórico está respaldado por un entorno de experimentación empírico reproducible basado en Docker, donde se simulan fallos inducidos de nodos y se evalúa el comportamiento del quórum y de *Erasure Coding* (Reed-Solomon).

---

## 📁 Estructura del Directorio

```text
TA-IND-01-Heiner Ariel Zambrano Ronquillo/
├── .gitignore                      # Reglas de exclusión para temporales de LaTeX y datos locales
├── AGENTS.md                       # Protocolo de integridad académica y alcance técnico
├── BITACORA.md                     # Registro cronológico diario del trabajo del estudiante
├── GUIA_DE_TAREA.txt               # Directrices, rúbrica y especificaciones de la actividad
├── README.md                       # Documentación global del repositorio y guía de ejecución
├── docker-source-build/            # Respaldo: Dockerfile multi-etapa desde código fuente (Go 1.24)
│   └── Dockerfile
├── experimento/                    # Entorno experimental y clúster distribuido
│   ├── docker-compose.yml          # Definición del clúster MinIO de 4 nodos (Chainguard hardened)
│   ├── comando_prueba.md           # Guía paso a paso de comandos de prueba y escenarios de falla
│   ├── preparar_prompt_captura.sh  # Script para estandarizar prompt con identidad (evidencias D3)
│   └── logs/                       # Registro de salidas reales de comandos y pruebas empíricas
│       └── .gitkeep
├── capturas/                       # Capturas originales de terminal y lecturas de artículos
│   └── .gitkeep
├── figura/                         # Diagramas de arquitectura y bosquejo a mano (Anexo A)
│   ├── .gitkeep
│   └── anexo_a_bosquejo_mano.jpg   # Fotografía del bosquejo inicial hecho a mano
├── Referencias/                    # Artículos científicos y literatura técnica consultada (PDFs)
│   └── .gitkeep
└── informe/                        # Documentación formal en formato académico (LaTeX)
    ├── main.tex                    # Estructura principal en LaTeX (13 secciones obligatorias)
    ├── main.pdf                    # Documento final compilado sin errores sintácticos
    └── referencias.bib             # Base de datos bibliográfica IEEE con Biber
```

---

## 🛠️ Instrucciones de Compilación del Documento (LaTeX)

El informe académico se redacta en LaTeX bajo la clase `article` en idioma español, utilizando **BibLaTeX** con estilo `ieee` y motor **Biber**. Para compilar el documento y garantizar la correcta resolución de hipervínculos, índices y citas bibliográficas:

```bash
# 1. Ingresar a la carpeta del informe
cd informe

# 2. Primera compilación para registrar etiquetas y secciones
pdflatex -interaction=nonstopmode main.tex

# 3. Procesamiento de la bibliografía IEEE
biber main

# 4. Segunda pasada de incorporación bibliográfica
pdflatex -interaction=nonstopmode main.tex

# 5. Pasada final para resolver referencias cruzadas y tabla de contenidos
pdflatex -interaction=nonstopmode main.tex
```

---

## 🚀 Despliegue y Ejecución del Experimento Local

Para reproducir el laboratorio distribuido de 4 nodos de MinIO:

1. **Ingresar a la carpeta del experimento:**
   ```bash
   cd experimento
   ```

2. **(Opcional) Cargar el prompt con identidad para evidencias:**
   ```bash
   source preparar_prompt_captura.sh
   ```

3. **Iniciar los 4 nodos en segundo plano:**
   ```bash
   docker compose up -d minio1 minio2 minio3 minio4
   ```
   *(El servicio `init-permissions` se ejecutará de forma automática asignando el UID `65532` requerido por las imágenes Chainguard).*

4. **Configurar el cliente MinIO (`mc`):**
   ```bash
   docker compose run --rm mc alias set localminio http://minio1:9000 minioadmin minioadmin123
   ```

5. **Protocolo de pruebas y simulación de fallas:**
   Consulte la guía detallada [experimento/comando_prueba.md](file:///c:/GIT/TA-IND-01--Análisis-Crítico-de-SD/TA-IND-01-Heiner%20Ariel%20Zambrano%20Ronquillo/experimento/comando_prueba.md) para verificar el quórum de lectura/escritura, inyectar caídas de nodos y observar la recuperación automática (*healing*).

---

## 🎥 Sustentación en Video

* **Enlace de la grabación:** *[ESPACIO RESERVADO: Se incluirá el enlace al video de YouTube (no listado) o Google Drive]*
* **Duración:** 3 a 5 minutos
* **Contenido:** Explicación técnica de la arquitectura de MinIO, justificación de una captura empírica y conclusiones principales.
