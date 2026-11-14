# Bitácora de Trabajo - TA-IND-01

## 11 de noviembre de 2026
- **Actividad:** Análisis de las opciones de sistemas distribuidos, elección de MongoDB como sistema principal y Apache Cassandra para la comparación. Registro del tema en el foro del SGA.
- **Problema encontrado:** Duda sobre si debía configurar ambos sistemas o solo uno.
- **Solución:** Se aclaró que el trabajo técnico fuerte es solo sobre MongoDB, y Cassandra es solo para teoría comparativa.
- **Tiempo dedicado:** 1 hora.
- **Resultado:** Repositorio creado en GitHub y estructura inicial de archivos LaTeX configurada.

## 12 de noviembre de 2026
- **Actividad:** Elaboración del bosquejo a mano de la arquitectura Replica Set de MongoDB (Anexo A). Búsqueda, lectura y captura de 3 artículos indexados con DOI para fundamentación teórica (Anexo B). Preparación del entorno Docker para pruebas de tolerancia a fallos.
- **Problema encontrado:** Riesgo de penalización en la dimensión D6 por enlaces rotos y configuración correcta de la red interna de Docker (`mongo-cluster`) para que los tres nodos pudieran comunicarse.
- **Solución:** Verificación manual de que los enlaces DOI abrieran el documento correcto. Uso del comando `docker network create` e inicialización del Replica Set mediante `rs.initiate` con los comandos específicos guardados en el archivo `comandos.txt`.
- **Tiempo dedicado:** 3 horas.

## 13 de noviembre de 2026 (Sesión 1 - Redacción e Informe)
- **Actividad:** Redacción final del informe académico en LaTeX, integrando el análisis de los conceptos de la Unidad 1, los resultados de la experimentación con contenedores y los ejemplos del entorno local (Jóvenes en Acción y Banco Pichincha). Configuración del formato bibliográfico IEEE e inclusión de la sección de declaración de uso de herramientas de IA.
- **Problema encontrado:** Las referencias bibliográficas no aparecían numeradas dentro de los párrafos, las tablas se generaban con la etiqueta "Cuadro" por defecto en el paquete de idioma, y se detectó una inconsistencia tipográfica en el informe al nombrar el contenedor de pruebas.
- **Solución:** Se insertaron los comandos `\cite{}` correspondientes en los párrafos para las citas IEEE, se añadió el comando `\renewcommand{\tablename}{Tabla}` en el preámbulo del documento, y se corrigió el error tipográfico en la sección de experimentación (de "mongol" a "mongo1") para coincidir exactamente con los comandos ejecutados en Docker. 
- **Tiempo dedicado:** 4.5 horas.
- **Resultado:** Documento base finalizado en cuanto a redacción, estructurado de manera técnica, sin errores ortotipográficos, compilado correctamente en PDF y respaldado mediante commits en el repositorio de GitHub.

## 13 de noviembre de 2026 (Sesión 2 - Elaboracion del diagrama en Drawio y video)
- **Actividad:** Subida e integración del diagrama arquitectónico al repositorio y grabación del video de sustentación (3 a 5 minutos) demostrando la tolerancia a fallos en el clúster. Actualización del archivo README.md con el enlace de acceso al video (YouTube no listado o Drive).
- **Problema encontrado:** Dificultad para sintetizar la explicación técnica del Teorema CAP/PACELC y la transición de estados de los nodos (al simular la caída de mongo1) en menos de 5 minutos y sin depender de un guion leído.
- **Solución:** Se diseñó una estructura de puntos clave (talking points) enfocada en la transición visual de las capturas de la terminal para explicar de forma empírica y fluida cómo el sistema bloquea escrituras, elige un nuevo líder primario para mantener la consistencia, y logra la transparencia de fallos.
- **Tiempo dedicado:** 1.5 horas.
- **Resultado:** Diagrama documentado, video de sustentación grabado y enlazado exitosamente en el README.md.
