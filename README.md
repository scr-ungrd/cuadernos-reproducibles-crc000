# Plantilla de Cuaderno Reproducible de Conocimiento del Riesgo

[![Hecho con MyST](https://img.shields.io/badge/hecho%20con-MyST-orange)](https://mystmd.org)
[![Abrir en Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/scr-ungrd/cuadernos-reproducibles-crc000/blob/main/notebooks/01_enos.ipynb)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/scr-ungrd/cuadernos-reproducibles-crc000/HEAD?labpath=notebooks/01_enos.ipynb)

Plantilla de la Subdirección para el Conocimiento del Riesgo (UNGRD) para crear un **cuaderno reproducible** y postularlo a la [convocatoria de Cuadernos Reproducibles](https://scr-ungrd.github.io/cuadernos-reproducibles/convocatoria-cuadernos/). Reúne en un solo repositorio:

- el artículo en MyST Markdown y un cuaderno de Jupyter ejecutable;
- los datos, la bibliografía y el entorno de ejecución;
- la publicación automática del **sitio web** en GitHub Pages;
- un **PDF** con el diseño de la serie (plantilla Typst propia) y las herramientas para maquetarlo.

El ejemplo incluido descarga el Índice Oceánico Niño (ONI) de la NOAA, clasifica las fases del ENOS (El Niño, La Niña y Neutral) y las grafica. Sustitúyelo por tu propio análisis.

> **Aviso:** la convocatoria está en fase piloto y abrirá el 1 de marzo de 2027. Los cuadernos publicados no han sido validados por personas expertas.

## Cómo usar la plantilla

1. En GitHub, pulsa **Use this template → Create a new repository** y elige un nombre público con el formato `cuadernos-reproducibles-crcNNN`. El identificador (CRC001, CRC002, …) se toma de ese nombre y se imprime en la portada del PDF.
2. Clónalo y crea el entorno:

   ```bash
   git clone https://github.com/<tu-usuario>/<tu-repositorio>.git
   cd <tu-repositorio>
   conda env create -f environment.yml
   conda activate cuaderno-reproducible
   ```

3. Reemplaza `notebooks/01_enos.ipynb` por tu cuaderno y edita `article.md`, `myst.yml`, `environment.yml`, `references.bib` y `CITATION.cff`.
   Si escribiste el cuaderno en MyST Markdown (`.md` con celdas `{code-cell}`), conviértelo con `jupytext --to ipynb cuaderno.md` y guarda el `.ipynb` en `notebooks/` con su número de orden.
4. Compila y revisa el sitio en tu equipo:

   ```bash
   npm install -g mystmd      # requiere Node 22 o superior
   myst start
   ```

5. Compila el PDF y ajústalo (ver [El PDF](#el-pdf)).
6. Cuando todo se ejecute completo y sin errores, sigue el proceso de postulación de la [convocatoria](https://scr-ungrd.github.io/cuadernos-reproducibles/convocatoria-cuadernos/).

## Estructura del repositorio

| Ruta | Contenido |
|---|---|
| `article.md` | Artículo principal en MyST Markdown: metadatos, resumen, caja *Stack* y las secciones del cuaderno |
| `notebooks/` | Cuadernos `.ipynb` numerados en orden de ejecución (`01_enos.ipynb` es el ejemplo) |
| `data/` | Datos de ejemplo o de prueba; si los descargas automáticamente, documenta la fuente |
| `images/` | Imágenes y figuras estáticas (`banner.png` es la imagen de encabezado) |
| `references.bib` | Bibliografía en BibTeX; también puedes citar con enlaces a DOI |
| `myst.yml` | Configuración: autores, afiliaciones, licencia, DOI, exportaciones y opciones del PDF |
| `environment.yml` | Dependencias del entorno de conda, con versiones exactas |
| `_templates/plain-typst-article/` | Plantilla Typst del PDF, su logo, el icono de Colab y la guía de diseño `DISENO_PDF.md` |
| `fonts/` | STIX Two Math (fuente de las ecuaciones del PDF) y su licencia |
| `scripts/` | `compilar_pdf.sh` y los scripts que miden y optimizan la maquetación del PDF |
| `.claude/agents/` | Agente `maquetacion-pdf` para Claude Code (opcional) |
| `CLAUDE.md` | Guía de trabajo para Claude Code en este repositorio (opcional) |
| `LICENSE` y `CITATION.cff` | Licencia del código (Apache 2.0) y metadatos de citación |
| `SECURITY.md` y `metadata/escaneo_seguridad.md` | Política de seguridad y registro del escaneo previo al *release* |
| `.github/workflows/deploy.yml` | Compila el sitio y el PDF y los publica en GitHub Pages en cada *push* a `main` |

## Estructura narrativa del cuaderno

Siguiendo la guía de la convocatoria, cada cuaderno debe tener estas secciones, escritas en celdas de texto MyST intercaladas con el código:

1. **Contexto y objetivo**
2. **Datos de entrada** (fuentes, formatos, resolución y limitaciones)
3. **Metodología** (paso a paso, con funciones documentadas)
4. **Resultados e interpretación**
5. **Limitaciones y recomendaciones**
6. **Referencias** (directiva `{bibliography}`)

Además, el artículo lleva una sección `## Stack` con un bloque de código `text` de 5 a 6 líneas «Etiqueta: valor» (herramienta principal, datos base, escenarios, punto de análisis y ejecución recomendada). El PDF la dibuja como una caja gris bajo las palabras clave de la portada.

## El PDF

El PDF se genera con la plantilla Typst de [`_templates/plain-typst-article/`](_templates/plain-typst-article/), que parte de [`cellpress-unofficial`](https://github.com/mewmew/cellpress-unofficial) (Robin Eklind, 0BSD) sin su marca. La plantilla es común a toda la serie: no la modifiques en tu cuaderno (los cambios de diseño se hacen primero en CRC001 y se replican). Lo que sí debes ajustar está en `myst.yml`, en la exportación `typst`:

```yaml
exports:
  - format: typst
    article: article.md
    output: article.pdf
    template: ./_templates/plain-typst-article
    titulo_breve: Plantilla cuaderno ENOS   # 2–4 palabras, pie de página
    version: v0.1.0                         # se imprime en la portada
    colab: https://colab.research.google.com/github/<org>/<repo>/blob/main/<cuaderno>.ipynb
    id: article-pdf
```

La portada muestra el título, los autores y sus afiliaciones, los datos de publicación (fecha, licencias, identificador, versión y enlace «Abrir en Colab»), el resumen, las palabras clave y la caja *Stack*. El pie lleva `título breve | DOI | fecha`. Los bloques de código y sus salidas de texto no se imprimen (están en el sitio web). Figuras y tablas son flotantes y se ubican donde caben.

### Compilar

```bash
sh scripts/compilar_pdf.sh     # PDF con las fuentes de fonts/, igual que el CI
myst build --typst             # equivalente, pero sin STIX Two Math si no está instalada
```

Requiere `typst` 0.15 en el `PATH`, mystmd 1.13 o superior, Node 22 o superior y la fuente Liberation Sans instalada. Con `jupyter: true` en `myst.yml`, la compilación ejecuta los cuadernos.

### Maquetar

Cuando agregues o cambies figuras y tablas, revisa el PDF con los scripts de `scripts/`:

| Script | Qué comprueba |
|---|---|
| `medir_huecos.py article.pdf` | Espacio en blanco al pie de cada página |
| `distancia_citas.py article.pdf` | Que cada figura o tabla aparezca a una página o menos de su mención |
| `figuras_juntas.py article.pdf` | Que no haya dos figuras seguidas sin un párrafo de texto en medio |
| `buscar_maquetacion.py` | Búsqueda automática de una mejor ubicación (solo cuadernos `.ipynb`) |

El procedimiento, las medidas del diseño, las alternativas de maquetación y las trampas conocidas están en [`DISENO_PDF.md`](_templates/plain-typst-article/DISENO_PDF.md). Si usas Claude Code, el agente `maquetacion-pdf` automatiza el proceso.

## Requisitos de calidad

Antes de postular, comprueba que:

- el cuaderno se ejecuta completo desde cero en un entorno limpio creado con `environment.yml`;
- ninguna celda depende de variables definidas fuera de orden y las rutas son relativas al repositorio;
- los datos son abiertos y están en `data/` o se descargan automáticamente;
- el repositorio es público, tiene licencia abierta, un *release* en GitHub y un DOI de [Zenodo](https://zenodo.org) (agrégalo en `myst.yml` y en `CITATION.cff`);
- cumples los estándares de la colección que apliquen a tu cuaderno:
  [guía para publicar](https://scr-ungrd.github.io/cuadernos-reproducibles/cuadernos-de-conocimiento/),
  [datos](https://scr-ungrd.github.io/cuadernos-reproducibles/estandar-de-datos/),
  [modelos](https://scr-ungrd.github.io/cuadernos-reproducibles/estandar-modelos/),
  [tableros](https://scr-ungrd.github.io/cuadernos-reproducibles/estandar-tableros/),
  [aplicaciones](https://scr-ungrd.github.io/cuadernos-reproducibles/estandar-aplicaciones/),
  [uso de IA](https://scr-ungrd.github.io/cuadernos-reproducibles/uso-de-ia/),
  [uso de LLMs](https://scr-ungrd.github.io/cuadernos-reproducibles/uso-de-llms/) y
  [seguridad](https://scr-ungrd.github.io/cuadernos-reproducibles/requisitos-seguridad/).

## Compilación del sitio

```bash
myst build --html     # sitio web en _build/html
myst build --all      # además PDF, JATS, MECA y LaTeX (el PDF de la serie es el de Typst)
```

Si el repositorio tiene activado GitHub Pages con **GitHub Actions** como fuente, el flujo `deploy.yml` publica el sitio y el PDF automáticamente en cada *push* a `main`. Cada *push* despliega; cada *release* de GitHub crea un registro permanente en Zenodo, así que publica solo cuando el CI del último *commit* esté en verde.

## Licencias

- **Código:** [Apache 2.0](LICENSE).
- **Texto, datos y figuras:** se recomienda [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.es).
- **Fuente STIX Two Math** (`fonts/`): SIL Open Font License 1.1, con su licencia en `fonts/OFL-STIX-Two.txt`.
- **Plantilla Typst:** adaptada de `cellpress-unofficial` (0BSD).
- **Logo de la serie** (`_templates/plain-typst-article/logo.svg`): identidad de la UNGRD. Úsalo solo en cuadernos de la colección y sin modificarlo, según el Manual de Identidad Visual de la entidad.
