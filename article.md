---
# File metadata may be provided as frontmatter YAML
title: Lorem Ipsum Dolor Sit Amet
subtitle: Consectetur adipiscing elit sed do eiusmod tempor incididunt
description: Lorem ipsum dolor sit amet, consectetur adipiscing elit
date: 2021-11-10
tags:
  - lorem
  - ipsum
  - dolor
thumbnail: images/banner.png
abstract: |
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. We have created an accessible dataset from this and completed preliminary data analysis which shows two distinct example groupings, consistent with a generic two-part model used for illustration purposes.
summary: |
  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur; analysis of the example dataset reveals two distinct groupings, supporting a generic dual-component model used purely for illustration.
data_availability: |
  The [`enos.ipynb`](./notebooks/enos.ipynb) notebook fetches the Oceanic Niño Index directly from the [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt) at runtime; no local copy of that dataset is required in the `data/` folder.
acknowledgments: |
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. The authors would like to thank the example working group for their help on creating these templates.
keypoints:
  - You may specify 1 to 3 keypoints for this PDF template
  - These keypoints are complete sentences and less than or equal to 140 characters
  - They are specific to this PDF template, so they will not appear in other exports plain
---

# Introduction

> The content of your article is written in MyST markdown and supports [standard markdown typography](https://mystmd.org/guide/typography) and many [directives and roles](https://mystmd.org/guide/syntax-overview) for figures, tables, equations, etc.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua [Figure %s](#map). Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

> Figures may be added to your article using the [figure directive](https://mystmd.org/guide/figures). They may refer to images saved in your `images/` folder, images from the web, or notebook cell outputs [referenced by label](https://mystmd.org/guide/cross-references#targeting-cells). The `:name:` is used to reference the figure in your text; a reference to the following figure is found in the paragraph above. The figure caption is given as the body of this directive.

```{figure} images/banner.png
:name: map
:align: center
:width: 100%

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Image credit [Example Source](https://example.com)
```

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur, an example structure that constitutes the illustrative portion of this template.

# Example History

A number of example events were recorded over time, these are summarized in [Table %s](#history).

> Simple tables may be created using the [list-table directive](https://mystmd.org/guide/tables). Similar to figures, tables may be referenced in the text by their `name`. The caption for this table is the first line of the directive.

```{list-table} Example recent historic events
:header-rows: 1
:name: history
* - Name
  - Year
* - Lorem
  - 2021
* - Ipsum
  - 1971
* - Dolor
  - 1949
* - Sit
  - 1712
* - Amet
  - 1677
* - Consectetur
  - 1646
* - Adipiscing
  - 1585
* - Elit
  - 1492
```

This equates to an example event on average every 79 years up until the 1971 event. The probability of a future event can be modeled by a Poisson distribution [](#poisson).

> Numbered equations may be defined using the [math directive or in line](https://mystmd.org/guide/math). Equations defined with the math directive may be reference in the text by label.

```{math}
:label: poisson

p(x)=\frac{e^{-\lambda} \lambda^{x}}{x !}
```

Where $\lambda$ is the number of eruptions per year, $\lambda=\frac{1}{79}$ in this case. The probability of a future eruption in the next $t$ years can be calculated by:

```{math}
:label: probability

p_e = 1-\mathrm{e}^{-t \lambda}
```

So following the 1971 example event the probability of a similar event in the following 50 years — the period ending this year — was 0.469. After the event, the rate moves to $\lambda=\frac{1}{75}$ and the probability of a further event within the next 50 years (2022-2071) rises to 0.487 and in the next 100 years, this rises again to 0.736.

## Example Model

> You may [add citations two ways](https://mystmd.org/guide/citations). First, you may simply insert a markdown link to a DOI like so: [](10.1093/nar/22.22.4673). No additional bibliographic information is required for this approach; the reference will be looked up by DOI and added implicitly to the references. Alternatively, you may provide the bibliography directly as `references.bib` BibTeX file, then embed the citation by BibTeX key in your text using the `@cite2023` or `[@cite2023; @cite2023b]` for narrative or parenthetical citations, respectively. The following paragraph provides an example of this. A single paper may combine both DOI and BibTeX citations.

Lorem ipsum studies, such as @loremipsum2024 have proposed a generic two-part example model; one component (30-40 example units) which feeds a second, shallower example component (10-20 example units).

In this template, we look at example data to see if we can see evidence of such a system in action.

# Dataset

> All data used in the notebook should be present in the `data/` folder so notebooks may be executed in place with no additional input.

As a worked example of pulling data from a live external source, the [`enos.ipynb`](./notebooks/enos.ipynb) notebook loads the Oceanic Niño Index (ONI) directly from the [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt), a public dataset released without restriction. The notebook fetches the ASCII table at build time, so no local copy needs to be kept in the `data/` folder for this example.

# Results

The ONI series was loaded and processed in the [`enos.ipynb`](./notebooks/enos.ipynb) notebook, converting the published 3-month running seasons into a time series and classifying each season as El Niño, La Niña, or Neutral using the standard ±0.5°C anomaly threshold.

```{figure} #fig-enso
:name: enso

Oceanic Niño Index (ONI) anomaly over time, colored by ENSO phase (El Niño / La Niña / Neutral).
This figure uses cell output from the [`enos.ipynb`](./notebooks/enos.ipynb) notebook. The first line of the [cell](#fig-enso) is `#| label: fig-enso`. Referencing that label pulls in the output of the cell as a figure.
```

From [Figure %s](#enso), we can see the alternating warm (El Niño) and cool (La Niña) phases through the historical record, with anomalies regularly exceeding the ±0.5°C classification threshold in both directions.

# Conclusions

This template demonstrates a complete example workflow in [`enos.ipynb`](./notebooks/enos.ipynb): fetching live data from a public NOAA source, processing it into a labeled time series, and embedding the resulting figure directly into this article via a notebook cell output reference.
