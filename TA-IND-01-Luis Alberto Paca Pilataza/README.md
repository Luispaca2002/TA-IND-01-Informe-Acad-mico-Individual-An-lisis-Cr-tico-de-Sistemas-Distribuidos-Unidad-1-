# TA-IND-01: Análisis Crítico de Sistemas Distribuidos

**Universidad Técnica Estatal de Quevedo (UTEQ)**  
**Facultad de Ciencias de la Ingeniería**  
**Carrera de Ingeniería de Software**

* **Asignatura:** Sistemas Distribuidos
* **Estudiante:** Luis Alberto Paca Pilataza
* **Curso/Paralelo:** 6 A
* **Fecha:** 13 de noviembre de 2026

---

## 📹 Video de Sustentación

En el siguiente enlace se encuentra el video de sustentación (3 a 5 minutos) donde se explica de forma empírica y mediante las capturas de la terminal de Docker, la tolerancia a fallos en el clúster de MongoDB y el cumplimiento del Teorema CAP/PACELC:

👉 **[Ver Video de Sustentación en Google Drive](https://drive.google.com/drive/folders/1AwEbYG_sn6LDUBMiJ0Ypeg3unhVufTeC?usp=sharing)**

*(Nota: El enlace tiene configurado el acceso abierto).*

---

## 📝 Descripción del Repositorio

Este repositorio contiene todos los artefactos generados para la Actividad TA-IND-01. El informe académico presenta un análisis crítico de la arquitectura distribuida de MongoDB, enfocado en su implementación de *Replica Sets* para garantizar alta disponibilidad y tolerancia a fallos.

El análisis se sustenta en la ejecución de un entorno local distribuido mediante contenedores Docker, donde se provocó deliberadamente la caída del nodo primario para observar y documentar el proceso algorítmico de elección de líder.

## 📂 Estructura del Proyecto

* `main.tex`: Código fuente del informe académico estructurado en formato IEEE.
* `main.pdf`: Documento final compilado listo para revisión.
* `comandos.txt`: Historial de los comandos utilizados para levantar la red virtual (`mongo-cluster`) y los nodos en Docker.
* Directorio de imágenes: Contiene las evidencias de ejecución de Docker, el diagrama arquitectónico digital (draw.io), el esquema inicial a mano y las capturas de los artículos científicos leídos.

---
*Repositorio creado para fines académicos - UTEQ 2026.*