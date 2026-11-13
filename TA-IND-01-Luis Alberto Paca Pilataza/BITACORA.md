# Bitácora de Trabajo - TA-IND-01

## 11 de noviembre de 2026
- **Actividad:** Análisis de las opciones de sistemas distribuidos, elección de MongoDB como sistema principal y Apache Cassandra para la comparación. Registro del tema en el foro del SGA.
- **Problema encontrado:** Duda sobre si debía configurar ambos sistemas o solo uno.
- **Solución:** Se aclaró que el trabajo técnico fuerte es solo sobre MongoDB, y Cassandra es solo para teoría comparativa.
- **Tiempo dedicado:** 1 hora.
- **Resultado:** Repositorio creado en GitHub y estructura inicial de archivos LaTeX configurada.
- ## 12 de noviembre de 2026
- **Actividad:** Elaboración del bosquejo a mano de la arquitectura Replica Set de MongoDB (Anexo A). Búsqueda, lectura y captura de 3 artículos indexados con DOI para fundamentación teórica (Anexo B). Preparación del entorno Docker para pruebas de tolerancia a fallos.
- **Problema encontrado:** Riesgo de penalización en la dimensión D6 por enlaces rotos y configuración correcta de la red interna de Docker (`mongo-cluster`) para que los tres nodos pudieran comunicarse.
- **Solución:** Verificación manual de que los enlaces DOI abrieran el documento correcto. Uso del comando `docker network create` e inicialización del Replica Set mediante `rs.initiate` con los comandos específicos guardados en el archivo `comandos.txt`.
- **Tiempo dedicado:** 3 horas.
