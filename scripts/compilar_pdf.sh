#!/bin/sh
# Compila el PDF con las fuentes del repositorio (fonts/: STIX Two Math para las
# ecuaciones), igual que el CI. Uso: sh scripts/compilar_pdf.sh
cd "$(dirname "$0")/.." || exit 1
TYPST_FONT_PATHS="$PWD/fonts" myst build --typst "$@"
