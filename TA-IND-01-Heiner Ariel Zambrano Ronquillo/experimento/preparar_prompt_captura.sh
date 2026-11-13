#!/usr/bin/env bash
# ==============================================================================
# Script de Preparación de Prompt de Terminal para Capturas de Evidencia
# Actividad: TA-IND-01 | Estudiante: Heiner Ariel Zambrano Ronquillo
# Cumplimiento: Evidencia de autoría D3 (Usuario, Hostname, Fecha/Hora con segundos, GitHub User)
# ==============================================================================

# Si no está definida externamente, establecer el usuario de GitHub del estudiante
export GITHUB_USER="${GITHUB_USER:-Heiner-ZZZ}"

# Configurar el prompt interactivo de Bash (PS1)
# Formato: [usuario@hostname] [YYYY-MM-DD HH:MM:SS] (gh:usuario_github) ruta_actual
#          $ 
export PS1='\[\e[01;32m\][\u@\h]\[\e[00m\] \[\e[01;33m\][\D{%Y-%m-%d %H:%M:%S}]\[\e[00m\] \[\e[01;35m\](gh:${GITHUB_USER})\[\e[00m\] \[\e[01;34m\]\w\[\e[00m\]\n\$ '

echo "=================================================================="
echo " Prompt de terminal configurado para capturas de evidencia TA-IND-01"
echo " Identidad activa: $(whoami) en $(hostname) | GitHub: ${GITHUB_USER}"
echo " Fecha y hora actual: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================================="
