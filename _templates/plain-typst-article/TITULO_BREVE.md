# Título breve del encabezado del PDF

El encabezado de las páginas 2 en adelante del PDF muestra un título breve a la izquierda y el DOI a la derecha. Se define en `myst.yml`, dentro de la exportación Typst:

```yaml
exports:
  - format: typst
    article: article.ipynb
    output: article.pdf
    template: ./_templates/plain-typst-article
    titulo_breve: Olas de calor Montería
    id: article-pdf
```

Si falta `titulo_breve`, el encabezado muestra «Cuaderno reproducible».

## Prompt para generarlo (cualquier cuaderno de la serie)

Copiar y pegar, reemplazando el título completo:

```text
Escribe el título breve del encabezado de un cuaderno reproducible de la serie
«Cuadernos Reproducibles de Conocimiento del Riesgo». Se imprime en el encabezado
de cada página del PDF, en una sola línea y en negrita, junto al DOI.

Título completo del cuaderno:
<PEGAR AQUÍ EL TÍTULO COMPLETO>

Reglas:
1. De 2 a 4 palabras y máximo 30 caracteres con espacios.
2. Nombra la amenaza o el tema principal y el lugar, en ese orden
   (por ejemplo: «Olas de calor Montería», «Sismicidad Colombia», «Tsunami Tumaco 1979»).
3. Sin verbos, sin artículos iniciales, sin signos de puntuación ni dos puntos,
   sin siglas poco conocidas y sin repetir «cuaderno», «riesgo» ni «análisis».
4. Español, con mayúscula inicial solo en la primera palabra y en los nombres propios.
5. No uses el título completo recortado: sintetiza el tema y el lugar.

Devuelve solo el título breve, sin comillas ni explicaciones.
```

## Valores

| Cuaderno | `titulo_breve` |
|---|---|
| CRC001 | Olas de calor Montería |
| CRC002 | Tsunami Tumaco 1979 (sugerido; confirmar) |
| CRC003 | Sismicidad Colombia (sugerido; confirmar) |
