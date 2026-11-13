# TA-IND-01: Informe Académico Individual - Análisis Crítico de Sistemas Distribuidos

**Universidad / Curso:** Sistemas Distribuidos - Unidad 1  
**Estudiante:** Kenny Isaías España Vera  
**Sistema Analizado Principal:** Apache Kafka (Modo KRaft)  
**Sistema Comparativo:** RabbitMQ  

---

## 📌 Descripción del Proyecto

Este repositorio contiene el desarrollo del informe académico individual correspondiente a la actividad **TA-IND-01: Análisis Crítico de Sistemas Distribuidos**. En este trabajo se analiza en profundidad la arquitectura, mecanismos de consenso, particionamiento, tolerancia a fallos y consistencia de datos de **Apache Kafka**, complementado con un experimento empírico reproducible desplegado en contenedores Docker y un contraste crítico frente a **RabbitMQ**.

---

## 📁 Estructura del Directorio

```text
KENNY ISAIAS ESPAÑA VERA/
├── BITACORA.md                      # Registro cronológico de actividades y resolución de problemas
├── README.md                        # Documentación general del proyecto y guía de compilación
├── evidencias/                      # Capturas de pantalla y registros de ejecución del experimento
│   └── .gitkeep
├── figuras/                         # Diagramas arquitectónicos e ilustraciones para el documento LaTeX
│   └── .gitkeep
└── experimento/                     # Entorno reproducible de pruebas
    ├── docker-compose.yml           # Clúster de Apache Kafka de 3 nodos en modo KRaft
    ├── comandos_prueba.md           # Guía paso a paso con comandos de prueba y simulación de fallos
    └── resultados_experimento.txt   # Registro detallado de la ejecución y salidas de terminal
```

---

## 🛠️ Instrucciones de Compilación del Documento (LaTeX)

El informe académico final se redacta en formato LaTeX con gestión bibliográfica mediante Biber / BibLaTeX (normas APA / IEEE). Para compilar el documento principal y generar el PDF sin inconsistencias en referencias cruzadas ni citas bibliográficas, ejecute la siguiente secuencia en su terminal:

```bash
# 1. Primera pasada para registrar citas y etiquetas
pdflatex informe.tex

# 2. Procesamiento de la bibliografía académica
biber informe

# 3. Segunda pasada para incorporar las referencias procesadas
pdflatex informe.tex

# 4. Pasada final para resolver numeración y referencias cruzadas
pdflatex informe.tex
```

---

## 🚀 Despliegue y Ejecución del Experimento Local

Para reproducir el experimento del clúster de 3 nodos de Kafka:

1. Ingrese a la carpeta del experimento:
   ```bash
   cd experimento
   ```
2. Inicie los contenedores en segundo plano:
   ```bash
   docker compose up -d
   ```
3. Consulte la guía [comandos_prueba.md](file:///C:/Users/Usuario/Desktop/KENNYAPP/TA-IND-01-Informe-Acad-mico-Individual-An-lisis-Cr-tico-de-Sistemas-Distribuidos-Unidad-1-/KENNY%20ISAIAS%20ESPA%C3%91A%20VERA/experimento/comandos_prueba.md) para verificar el quórum KRaft, crear el topic distribuido y simular la desconexión del broker líder.

---

## 🎥 Sustentación en Video

- **Enlace de la grabación:** *[ESPACIO RESERVADO - Se agregará el enlace del video de sustentación]*
- **Plataforma:** YouTube / Google Drive / OneDrive
- **Duración aproximada:** 5 - 10 minutos
