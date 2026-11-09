# Plantilla de Cuaderno Reproducible de Conocimiento del Riesgo

[![Hecho con MyST](https://img.shields.io/badge/hecho%20con-MyST-orange)](https://mystmd.org)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/scr-ungrd/cuadernos-reproducibles-crc000/HEAD?labpath=notebooks/enos.ipynb)

Plantilla de la Subdirección para el Conocimiento del Riesgo (UNGRD) para crear un **cuaderno reproducible** y postularlo a la [convocatoria de Cuadernos Reproducibles](https://scr-ungrd.github.io/cuadernos-reproducibles/convocatoria-cuadernos/). Reúne un artículo en MyST Markdown, un cuaderno de Jupyter ejecutable, datos, bibliografía y la configuración de compilación.

El ejemplo incluido descarga el Índice Oceánico Niño (ONI) de la NOAA, clasifica las fases del ENOS (El Niño, La Niña y Neutral) y las grafica. Sustitúyelo por tu propio análisis.

> **Aviso:** el proyecto de cuadernos reproducibles está en fase piloto; la convocatoria aún no se ha abierto y los cuadernos no han sido validados por expertos.

## Cómo usar la plantilla

1. En GitHub, pulsa **Use this template → Create a new repository** y elige un nombre para tu repositorio público.
2. Clónalo y crea el entorno:

   ```bash
   git clone https://github.com/<tu-usuario>/<tu-repositorio>.git
   cd <tu-repositorio>
   conda env create -f environment.yml
   conda activate cuaderno-reproducible
   ```

3. Reemplaza `notebooks/enos.ipynb` por tu cuaderno y edita `article.md`, `myst.yml`, `environment.yml` y `references.bib`.
4. Compila y revisa el sitio en tu equipo:

   ```bash
   npm install -g mystmd
   myst start
   ```

5. Cuando todo se ejecute completo y sin errores, sigue el proceso de postulación de la [convocatoria](https://scr-ungrd.github.io/cuadernos-reproducibles/convocatoria-cuadernos/).

## Estructura del repositorio

| Ruta | Contenido |
|---|---|
| `article.md` | Artículo principal en MyST Markdown, con metadatos, resumen y figuras incrustadas desde el cuaderno |
| `notebooks/` | Cuadernos `.ipynb` numerados en orden de ejecución (`enos.ipynb` es el ejemplo) |
| `data/` | Datos de ejemplo o de prueba; si descargas los datos automáticamente, documenta la fuente |
| `images/` | Imágenes y figuras estáticas (`banner.png` es la imagen de encabezado) |
| `references.bib` | Bibliografía en BibTeX; también puedes citar con enlaces a DOI |
| `myst.yml` | Configuración del proyecto: autores, afiliaciones, licencia, DOI, exportaciones |
| `environment.yml` | Dependencias del entorno de conda |
| `LICENSE` y `CITATION.cff` | Licencia del código (Apache 2.0) y metadatos de citación |
| `.github/workflows/deploy.yml` | Compila y publica el sitio en GitHub Pages en cada *push* a `main` |

## Estructura narrativa del cuaderno

Siguiendo la guía de la convocatoria, cada cuaderno debe tener estas secciones, escritas en celdas de texto MyST intercaladas con el código:

1. **Contexto y objetivo**
2. **Datos de entrada** (fuentes, formatos, resolución y limitaciones)
3. **Metodología** (paso a paso, con funciones documentadas)
4. **Resultados e interpretación**
5. **Limitaciones y recomendaciones**
6. **Referencias** (directiva `{bibliography}`)

## Requisitos de calidad

Antes de postular, comprueba que:

- el cuaderno se ejecuta completo desde cero en un entorno limpio creado con `environment.yml`;
- ninguna celda depende de variables definidas fuera de orden y las rutas son relativas al repositorio;
- los datos son abiertos y están en `data/` o se descargan automáticamente;
- el repositorio es público, tiene licencia abierta, un *release* en GitHub y un DOI de [Zenodo](https://zenodo.org) (agrégalo en `myst.yml` y en `CITATION.cff`).

## Compilación

```bash
myst build --html   # sitio web en _build/html
myst build --all    # además PDF, JATS, MECA y LaTeX (requiere TeX)
```

Si el repositorio tiene activado GitHub Pages con **GitHub Actions** como fuente, el flujo `deploy.yml` publica el sitio automáticamente.

## Licencias

El código se distribuye bajo licencia [Apache 2.0](LICENSE). Se recomienda publicar los datos y la documentación narrativa bajo [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.es).
