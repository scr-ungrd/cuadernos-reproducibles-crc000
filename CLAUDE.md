# CLAUDE.md

Plantilla CRC000 de la serie Cuadernos Reproducibles de Conocimiento del Riesgo (UNGRD). Se escribe en MyST (`article.md` + `notebooks/`) y se publica como sitio HTML y como PDF con una plantilla Typst propia.

## Construcción

```bash
myst build --html      # sitio
myst build --typst     # PDF (article.pdf), usa _templates/plain-typst-article/
sh scripts/compilar_pdf.sh   # igual, pero con las fuentes de fonts/ (STIX Two Math), como el CI
```

Requiere mystmd >= 1.13 y Node >= 22. `jupyter: true` ejecuta los cuadernos al compilar.

## Diseño del PDF

La especificación completa (valores, prompts, procedimiento de maquetación y trampas) está en `_templates/plain-typst-article/DISENO_PDF.md`: léela antes de tocar `style.typ`. Resumen: logo arriba a la izquierda en todas las páginas, sin encabezado, pie «título breve | DOI | fecha», título y encabezados en azul `#213362`, portada con datos de publicación (incluye *Identificador*, *Versión* y enlace «Abrir en Colab») y resumen, caja gris «Stack» bajo las palabras clave, figuras y tablas flotantes, metadatos del PDF y ecuaciones en STIX Two Math.

- El título breve (`titulo_breve` en `myst.yml`) se genera con el prompt de `_templates/plain-typst-article/TITULO_BREVE.md`. Las opciones `version` y `colab` de la exportación Typst (también en `myst.yml`) alimentan la portada.
- Para reducir huecos y ubicar mejor figuras y tablas, usa el agente `maquetacion-pdf` (`.claude/agents/maquetacion-pdf.md`) o el procedimiento de la sección 6 de `DISENO_PDF.md`; mide con `scripts/medir_huecos.py`, `scripts/distancia_citas.py` y `scripts/figuras_juntas.py` (regla: nunca dos figuras seguidas sin un párrafo en medio); `scripts/buscar_maquetacion.py` automatiza la búsqueda en cuadernos `.ipynb`.
- `style.typ`, `template.typ` y `template.yml` son comunes a toda la serie: los cambios de diseño se hacen primero en CRC001 y se replican; un cuaderno concreto solo reordena su propio texto y figuras.

## Reglas

- No hagas commit, push ni release sin que el usuario lo pida: cada push a `main` despliega Pages y cada release crea un registro permanente en Zenodo.
