---
title: Plantilla de Cuaderno Reproducible de Conocimiento del Riesgo
subtitle: Estructura, metadatos y ejemplo ejecutable con el Índice Oceánico Niño (ONI)
description: Plantilla en MyST para los Cuadernos Reproducibles de Conocimiento del Riesgo de Desastres de la UNGRD, con la estructura narrativa y los requisitos de la convocatoria.
date: 2026-11-09
tags:
  - plantilla
  - cuaderno reproducible
  - MyST
  - ENOS
thumbnail: images/banner.png
abstract: |
  Esta plantilla reúne la estructura mínima que deben tener los cuadernos postulados a la convocatoria de Cuadernos Reproducibles de Conocimiento del Riesgo de Desastres de la UNGRD: metadatos, narrativa científica en MyST, código ejecutable, figuras, tablas, ecuaciones, referencias y control de calidad. Como caso de ejemplo se descarga, procesa y visualiza el Índice Oceánico Niño (ONI) de la NOAA, de modo que el artículo incrusta directamente la figura generada por un cuaderno de Jupyter.
summary: |
  Plantilla de la UNGRD para publicar cuadernos reproducibles de gestión del riesgo, ilustrada con el Índice Oceánico Niño (ONI).
data_availability: |
  El cuaderno [`enos.ipynb`](./notebooks/enos.ipynb) descarga el Índice Oceánico Niño directamente del [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt) al compilar el artículo; los datos son públicos y no se guarda una copia en `data/`. Los cuadernos que usen datos no descargables automáticamente deben incluir en `data/` un conjunto de muestra y documentar el acceso a la fuente.
acknowledgments: |
  Plantilla de la Subdirección para el Conocimiento del Riesgo de la UNGRD, adaptada de la [plantilla de envío de MyST](https://mystmd.org) y de [opengeos/myst-article-template](https://github.com/opengeos/myst-article-template).
keypoints:
  - La plantilla sigue la estructura narrativa exigida por la convocatoria de la UNGRD
  - Cada sección muestra una directiva de MyST - citas, tablas, figuras, ecuaciones y código ejecutable
  - El ejemplo aplicado clasifica las fases del ENOS con el ONI en el cuaderno enos.ipynb
---

# Contexto y objetivo

> Este archivo es el artículo principal del proyecto. Se escribe en MyST Markdown y admite la [tipografía estándar de markdown](https://mystmd.org/guide/typography) y numerosas [directivas y roles](https://mystmd.org/guide/syntax-overview). Las notas en formato de cita, como esta, explican la directiva que se muestra a continuación; bórralas cuando uses la plantilla.

Todo cuaderno de esta colección debe presentar el problema, la escala territorial y la justificación de la metodología. Aquí el problema es sencillo y sirve de ejemplo: determinar en qué fase del fenómeno El Niño–Oscilación del Sur (ENOS) se encuentra el Pacífico ecuatorial, porque esa fase condiciona la lluvia y la temperatura en Colombia y, con ellas, la amenaza por sequías, incendios de cobertura vegetal e inundaciones.

## Cómo usar esta plantilla

1. Crea tu repositorio con **Use this template** en GitHub.
2. Reemplaza el cuaderno `notebooks/enos.ipynb` por el tuyo y conserva su estructura narrativa.
3. Actualiza `myst.yml` (título, autores, afiliaciones, palabras clave), `environment.yml` y `references.bib`.
4. Reescribe este artículo con el resumen y los resultados de tu análisis.
5. Verifica que todo se ejecute desde cero con `myst build --html` y postula tu cuaderno siguiendo la [convocatoria](https://scr-ungrd.github.io/cuadernos-reproducibles/convocatoria-cuadernos/).

# Metadatos (frontmatter)

> El bloque YAML al inicio del archivo, delimitado por `---`, define los metadatos del artículo: título, resumen (`abstract`), palabras clave, disponibilidad de datos y agradecimientos, entre otros campos de la [documentación de frontmatter](https://mystmd.org/guide/frontmatter). Los metadatos del proyecto completo (autores, afiliaciones, licencia, DOI) se definen en `myst.yml`.

La guía de la convocatoria pide que el repositorio incluya, como mínimo, título, autores, institución, palabras clave temáticas (amenaza, departamento y escala espacial) y el DOI de Zenodo. Los dos primeros niveles de metadatos se editan en este encabezado y en `myst.yml`.

# Datos de entrada

> Todos los datos deben estar en la carpeta `data/` o poder obtenerse en tiempo de ejecución desde una fuente abierta, como en este ejemplo. Documenta siempre la fuente, el formato, la resolución espaciotemporal y las limitaciones.

El cuaderno [`enos.ipynb`](./notebooks/enos.ipynb) descarga el Índice Oceánico Niño (ONI) del [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt): la media móvil de tres meses de la anomalía de la temperatura superficial del mar en la región Niño 3.4 [@trenberth1997; @huang2017]. Los datos son públicos, no requieren registro y se publican como una tabla ASCII.

> Las tablas simples se crean con la [directiva list-table](https://mystmd.org/guide/tables) y se referencian en el texto por su `name`.

```{list-table} Resumen de la fuente de datos del ejemplo
:header-rows: 1
:name: tab-datos

* - Característica
  - Detalle
* - Fuente
  - NOAA Climate Prediction Center
* - Variable
  - Anomalía de la temperatura superficial del mar, región Niño 3.4 (°C)
* - Resolución temporal
  - Temporadas móviles de 3 meses, desde 1950
* - Acceso
  - Público y gratuito, sin registro
```

La [Tabla %s](#tab-datos) resume la fuente. Las tablas de este tipo ayudan a cumplir el principio de datos *Accesibles* de FAIR.

# Metodología

> Los fragmentos de código se ejecutan al compilar el artículo con la directiva `code-cell`, y su salida se incrusta en el documento. La explicación narrativa debe cubrir el *por qué* de cada decisión: parámetros, umbrales y fuentes.

```{code-cell} ipython3
print("¡Hola, MyST! Este código se ejecuta al compilar el artículo.")
```

El cuaderno convierte las temporadas móviles en una serie de tiempo (usando el mes central de cada temporada) y clasifica cada una como El Niño, La Niña o Neutral con el umbral estándar de ±0,5 °C. La probabilidad de que ocurra al menos un evento durante un periodo puede expresarse con una distribución de Poisson [](#poisson), un ejemplo del uso de ecuaciones numeradas.

> Las ecuaciones se definen con la [directiva math](https://mystmd.org/guide/math) y se referencian por su etiqueta.

```{math}
:label: poisson

p(x)=\frac{e^{-\lambda} \lambda^{x}}{x !}
```

donde $\lambda$ es la tasa de ocurrencia del evento por año. La probabilidad de que ocurra al menos un evento en los próximos $t$ años es:

```{math}
:label: probabilidad

p_e = 1-\mathrm{e}^{-t \lambda}
```

> Las citas se agregan de dos maneras ([guía](https://mystmd.org/guide/citations)): con un enlace a un DOI, como [](10.1175/JCLI-D-16-0836.1), o con una clave del archivo `references.bib`, como en `@trenberth1997`. Ambos estilos pueden combinarse.

# Resultados e interpretación

> Las figuras se agregan con la [directiva figure](https://mystmd.org/guide/figures). Pueden ser imágenes de `images/`, imágenes de la web o la salida de una celda de un cuaderno, [referenciada por su etiqueta](https://mystmd.org/guide/cross-references#targeting-cells).

```{figure} #fig-enso
:name: enso

Anomalía del Índice Oceánico Niño (ONI) a lo largo del tiempo, coloreada según la fase del ENOS (El Niño, La Niña o Neutral). La figura es la salida de la celda con la etiqueta `#| label: fig-enso` del cuaderno [`enos.ipynb`](./notebooks/enos.ipynb).
```

La [Figura %s](#enso) muestra la alternancia entre fases cálidas y frías, con anomalías que superan de manera recurrente el umbral de ±0,5 °C. Entre las temporadas más recientes de la serie, el índice pasa de condiciones frías a finales de 2025 a un episodio cálido en desarrollo en 2026. Para interpretar esta información en términos de riesgo, consulta el cuaderno [CRC-006: Escenarios de riesgo ante el fenómeno El Niño 2026–2027](https://scr-ungrd.github.io/cuadernos-reproducibles-crc006/).

# Limitaciones y recomendaciones

Discute con honestidad los supuestos, las incertidumbres no cuantificadas y las extensiones posibles. En este ejemplo, el ONI es un índice global del Pacífico ecuatorial y no describe por sí solo los impactos locales en Colombia; para ello hay que cruzarlo con series de precipitación y temperatura del IDEAM y con registros de eventos.

# Control de calidad antes de la entrega

Antes de postular tu cuaderno, verifica que:

- Se ejecuta completo desde cero en un entorno creado con `environment.yml`.
- Ninguna celda depende de variables definidas fuera de orden.
- Las rutas son relativas al repositorio.
- El repositorio tiene licencia abierta, un *release* en GitHub y un DOI de Zenodo.

# Instalación y compilación

```bash
git clone https://github.com/<tu-usuario>/<tu-repositorio>.git
cd <tu-repositorio>
conda env create -f environment.yml
conda activate cuaderno-reproducible
npm install -g mystmd
myst build --html
```

Para generar también el PDF y las demás exportaciones definidas en `myst.yml`, usa `myst build --all`.

# Referencias

```{bibliography}
```
