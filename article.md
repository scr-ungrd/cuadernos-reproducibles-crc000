---
# Los metadatos del archivo se especifican como YAML de frontmatter
title: Plantilla de Artículo MyST en Español
subtitle: Cómo se documentan las partes de un artículo reproducible en MyST
description: Plantilla en español que recorre las secciones y directivas típicas de un artículo MyST, aplicadas al ejemplo del Índice Oceánico Niño (ONI).
date: 2026-07-24
tags:
  - myst
  - plantilla
  - artículo reproducible
thumbnail: images/banner.png
abstract: |
  Esta plantilla presenta, en español, las partes que componen un artículo científico reproducible escrito en MyST Markdown: metadatos, introducción, figuras, tablas, ecuaciones, citas, código ejecutable y datos. Como caso de aplicación se usa el Índice Oceánico Niño (ONI), publicado por el NOAA Climate Prediction Center, para mostrar cómo incrustar en el artículo la salida de un cuaderno de Jupyter.
summary: |
  Guía en español de las partes de un artículo MyST, ilustrada con el procesamiento y la visualización del Índice Oceánico Niño (ONI).
data_availability: |
  El cuaderno [`enos.ipynb`](./notebooks/enos.ipynb) obtiene el Índice Oceánico Niño directamente del [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt) en tiempo de compilación; no se requiere guardar una copia local de estos datos en la carpeta `data/`.
acknowledgments: |
  Plantilla adaptada al español a partir de la plantilla oficial de MyST y de la organización de contenidos de [opengeos/myst-article-template](https://github.com/opengeos/myst-article-template).
keypoints:
  - Esta plantilla documenta en español las partes de un artículo MyST
  - Cada sección ilustra una directiva distinta - figuras, tablas, ecuaciones, citas y código ejecutable
  - El ejemplo aplicado usa el Índice Oceánico Niño del cuaderno enos.ipynb
---

# Introducción

> El contenido de tu artículo se escribe en MyST Markdown y admite la [tipografía estándar de markdown](https://mystmd.org/guide/typography), además de numerosas [directivas y roles](https://mystmd.org/guide/syntax-overview) para figuras, tablas, ecuaciones, código ejecutable, etc.

Esta plantilla recorre, sección por sección, las partes habituales de un artículo MyST: los metadatos del frontmatter, el texto narrativo, las figuras, las tablas, las ecuaciones, las citas y el código ejecutable. Cada apartado incluye una nota como esta, en formato de cita, que explica la directiva correspondiente antes de mostrarla en uso.

## A quién está dirigida esta plantilla

Esta plantilla está pensada para autores de habla hispana que quieran preparar un artículo reproducible con MyST: informes técnicos, notas de análisis de datos o artículos científicos que combinen texto, código y figuras generadas a partir de cuadernos de Jupyter.

## Cómo leer este artículo

Cada sección se apoya en la anterior. Las citas en formato de bloque (como las de este párrafo) explican qué directiva de MyST se está usando; el texto que sigue muestra un ejemplo concreto de esa directiva.

# Metadatos del artículo (frontmatter)

> El bloque YAML al inicio de este archivo, delimitado por `---`, define los metadatos del artículo: título, subtítulo, autores, resumen (`abstract`), palabras clave, disponibilidad de datos y agradecimientos, entre otros campos descritos en la [documentación de frontmatter de MyST](https://mystmd.org/guide/frontmatter). Los metadatos del proyecto completo -autores, afiliaciones, licencia, financiamiento- se definen en `myst.yml`.

Revisa el encabezado de este archivo y el archivo `myst.yml` en la raíz del proyecto para ver ejemplos de ambos niveles de metadatos: los específicos de este artículo y los del proyecto en su conjunto.

# Primeros pasos

## Conceptos clave

> Puedes [agregar citas de dos maneras](https://mystmd.org/guide/citations). La primera es insertar un enlace de markdown a un DOI, así: [](10.1093/nar/22.22.4673); no se requiere información bibliográfica adicional, ya que la referencia se busca automáticamente por su DOI. La segunda es declarar la bibliografía en un archivo BibTeX, por convención `references.bib`, y citar por clave con `@cite2023` o `[@cite2023; @cite2023b]` para citas narrativas o parentéticas, respectivamente. Un mismo artículo puede combinar ambos estilos.

Estudios de ejemplo, como @loremipsum2024, proponen un modelo genérico de dos componentes; una primera parte (30-40 unidades de ejemplo) que alimenta una segunda componente, más superficial (10-20 unidades de ejemplo).

```{code-cell} ipython3
print("¡Hola, MyST!")
```

> Las celdas de código como la anterior, definidas con la directiva `code-cell`, se ejecutan al compilar el artículo y su salida se incrusta directamente en el documento.

## Herramientas empleadas

> Las tablas simples se crean con la [directiva list-table](https://mystmd.org/guide/tables). Igual que las figuras, pueden referenciarse en el texto mediante su `name`. La primera línea de la directiva es el título de la tabla.

```{list-table} Herramientas empleadas en esta plantilla
:header-rows: 1
:name: tab-herramientas

* - Herramienta
  - Descripción
  - Versión
* - Python
  - Lenguaje de programación
  - 3.x
* - pandas
  - Manejo de datos tabulares
  - ver `environment.yml`
* - Matplotlib
  - Generación de figuras
  - ver `environment.yml`
* - MyST
  - Marco de autoría en markdown
  - ver `mystmd` instalado
```

Como se ve en la [Tabla %s](#tab-herramientas), el entorno se define de forma reproducible en `environment.yml`.

# Instalación

## Requisitos previos

Para compilar este artículo necesitas Node.js (para el CLI de MyST) y un entorno de Python con las dependencias listadas en `environment.yml`.

## Pasos de instalación

```bash
npm install -g mystmd
conda env create -f environment.yml
```

## Verificar la instalación

```{code-cell} ipython3
import sys
print(f"Versión de Python: {sys.version}")
```

Luego compila todas las exportaciones definidas en `myst.yml`:

```bash
myst build --all
```

# Figuras

> Las figuras se agregan con la [directiva figure](https://mystmd.org/guide/figures). Pueden referirse a imágenes guardadas en la carpeta `images/`, imágenes en la web, o salidas de celdas de un cuaderno [referenciadas por etiqueta](https://mystmd.org/guide/cross-references#targeting-cells). El atributo `:name:` permite referenciar la figura en el texto, como en el párrafo siguiente.

```{figure} images/banner.png
:name: banner
:align: center
:width: 100%

Imagen de encabezado de la plantilla, referenciada como [Figura %s](#banner) en el texto.
```

# Ecuaciones

> Las ecuaciones numeradas se definen con la [directiva math o en línea](https://mystmd.org/guide/math). Las ecuaciones definidas con la directiva math pueden referenciarse en el texto por su etiqueta.

La probabilidad de que ocurra un evento puede modelarse con una distribución de Poisson [](#poisson).

```{math}
:label: poisson

p(x)=\frac{e^{-\lambda} \lambda^{x}}{x !}
```

Donde $\lambda$ es la tasa de ocurrencia del evento por año. La probabilidad de que ocurra al menos un evento en los próximos $t$ años se calcula como:

```{math}
:label: probability

p_e = 1-\mathrm{e}^{-t \lambda}
```

# Datos y resultados

> Todos los datos usados en el cuaderno deben estar disponibles en la carpeta `data/`, o bien obtenerse en tiempo de ejecución desde una fuente externa, como en el ejemplo siguiente.

Como ejemplo de obtención de datos desde una fuente externa en vivo, el cuaderno [`enos.ipynb`](./notebooks/enos.ipynb) carga el Índice Oceánico Niño (ONI) directamente del [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt), un conjunto de datos público sin restricciones de uso. El cuaderno descarga la tabla ASCII al momento de compilar el artículo, por lo que no es necesario mantener una copia local en la carpeta `data/`.

La serie del ONI se procesa en el cuaderno [`enos.ipynb`](./notebooks/enos.ipynb), convirtiendo las temporadas móviles de 3 meses publicadas en una serie de tiempo y clasificando cada temporada como El Niño, La Niña o Neutral usando el umbral estándar de anomalía de ±0.5°C.

```{figure} #fig-enso
:name: enso

Anomalía del Índice Oceánico Niño (ONI) a lo largo del tiempo, coloreada según la fase ENOS (El Niño / La Niña / Neutral).
Esta figura usa la salida de una celda del cuaderno [`enos.ipynb`](./notebooks/enos.ipynb). La primera línea de la [celda](#fig-enso) es `#| label: fig-enso`; referenciar esa etiqueta incorpora la salida de la celda como figura.
```

En la [Figura %s](#enso) se observa la alternancia entre fases cálidas (El Niño) y frías (La Niña) a lo largo del registro histórico, con anomalías que superan regularmente el umbral de clasificación de ±0.5°C en ambas direcciones.

# Conclusión

Esta plantilla mostró, en español, las partes principales de un artículo MyST -metadatos, figuras, tablas, ecuaciones, citas y código ejecutable- usando como caso aplicado el flujo completo del cuaderno [`enos.ipynb`](./notebooks/enos.ipynb): obtención de datos en vivo desde una fuente pública de NOAA, su procesamiento en una serie de tiempo clasificada, y la incorporación de la figura resultante directamente en el artículo mediante la referencia a la salida de una celda.

## Agradecimientos

Plantilla adaptada al español a partir de la plantilla oficial de MyST y de la organización de contenidos de [opengeos/myst-article-template](https://github.com/opengeos/myst-article-template).
