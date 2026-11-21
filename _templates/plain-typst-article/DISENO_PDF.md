# Diseño del PDF (plantilla Typst) de la serie Cuadernos Reproducibles

Especificación completa del PDF de CRC001, pensada para reproducirlo en cualquier cuaderno de la serie (CRC000 es la plantilla base). Los valores salen de `style.typ`, `template.typ` y `template.yml` de esta carpeta. Si cambias un valor aquí, cámbialo también en esos archivos, y al revés.

La plantilla parte de `cellpress-unofficial` (Robin Eklind, 0BSD) y se compila con mystmd: `myst build --typst` (exportación `format: typst` de `myst.yml`, `template: ./_templates/plain-typst-article`).

## 1. Archivos de la plantilla

| Archivo | Para qué sirve |
|---|---|
| `template.yml` | Declara archivos (`template.typ`, `style.typ`, `subpar-wrap.typ`, `logo.svg`), campos del documento, la opción `titulo_breve` y las partes (`abstract`, `data_availability`, `keypoints`) |
| `template.typ` | Plantilla jinja de mystmd: arma los metadatos, llama a `template` y `front-page`, escribe el contenido, «Disponibilidad de Datos» y la bibliografía |
| `style.typ` | Todo el diseño: colores, página, portada, pie, títulos, tablas, figuras, caja Stack, bibliografía |
| `subpar-wrap.typ` | Alinea a la izquierda las leyendas de tablas y las pega a la tabla |
| `../../fonts/` | (en la raíz del repositorio) STIX Two Math y su licencia, para las ecuaciones |
| `colab.svg` | Icono simplificado de Google Colab de la portada |
| `logo.svg` | Logo de la serie (copia recortada de `Diagramacion/Logo/logo_Cuadernos_Reproducibles_UNGRD_vector.svg`, `viewBox="0 70 2100 520"`) |
| `TITULO_BREVE.md` | Prompt para generar el título breve del pie |
| `DISENO_PDF.md` | Este documento |

Además: `scripts/medir_huecos.py` (mide el espacio en blanco por página), `scripts/distancia_citas.py` (distancia a la mención) y `scripts/figuras_juntas.py` (figuras pegadas) y, en CRC000, el agente `.claude/agents/maquetacion-pdf.md`.

## 2. Configuración de `myst.yml`

```yaml
project:
  exports:
    - format: typst
      article: article.ipynb          # o article.md
      output: article.pdf
      template: ./_templates/plain-typst-article
      titulo_breve: Olas de calor Montería   # 2–4 palabras, ver TITULO_BREVE.md
      version: v2.0.0                        # se imprime bajo «Código» en la portada
      colab: https://colab.research.google.com/github/<org>/<repo>/blob/main/<cuaderno>.ipynb
      id: article-pdf
```

mystmd avisa «'venue' extra key ignored: titulo_breve»: es inofensivo, la opción sí llega a la plantilla. Campos que la portada lee: `title`, `authors` (con `affiliations`), `affiliations` (nombre, dependencia, ciudad, país), `doi`, `date`, `license.content`, `license.code`, `keywords`, `github` y el resumen (`parts.abstract`).

## 3. Especificación visual

**Tipografía.** Liberation Sans en todo (se instala en CI con `fonts-liberation`). Texto 8,4 pt, justificado, idioma `es`; párrafos sin sangría, con el espacio por defecto de Typst entre ellos (1,2 em ≈ 10,1 pt). Se probó la sangría de primera línea de 1,2 em con 0,65 em entre párrafos (estilo Nature Communications) y se revirtió. Código y Stack en monoespaciada por defecto de Typst. Enlaces, citas y referencias cruzadas en azul `#0296d3`. **Ecuaciones:** STIX Two Math (trazo más firme, combina mejor con el texto sans que New Computer Modern Math, la de Typst por defecto), con New Computer Modern Math como respaldo. **La fuente viaja en el repositorio** (`fonts/STIXTwoMath-Regular.otf`, versión oficial 2.13b171, SIL OFL 1.1, licencia en `fonts/OFL-STIX-Two.txt`) y se activa con la variable `TYPST_FONT_PATHS=fonts`: el CI la define en el paso de compilación y en local se usa `sh scripts/compilar_pdf.sh`. Así el PDF es idéntico en cualquier máquina. **Metadatos del PDF:** título, autores, palabras clave y fecha de publicación (a las 12:00 para que el día no cambie por zona horaria) salen de `set document(...)` en `style.typ`.

**Colores.** Azul de títulos `#213362` (azul del logo; constante `heading-color`); gris de cajas `#ebebec`; encabezado de tabla `luma(87%)`; filas alternas `luma(94%)`; línea gruesa de tablas `luma(15%)`; línea fina `0,35 pt` negra.

**Página.** Carta (8,5 × 11 in). Márgenes: izquierdo 112 pt, derecho 66,17 pt (52 pt + 5 mm) (proporciones de la página 2 de un artículo de Annual Reviews), superior 80 pt, inferior 93,19 pt (45 pt + 1 cm + 7 mm de aire sobre el pie; `footer-descent` 56,79 pt deja la línea del pie en su sitio, a 755,6 pt del borde superior). Ancho de texto 433,8 pt. Una sola columna.

**Logo.** En el fondo de todas las páginas, esquina superior izquierda: `dx` 36 pt, `dy` 12 pt, ancho 170 pt (constantes `logo-x`, `logo-y`, `logo-w`). Imita el logo colgante del PDF de PLOS (`Diagramacion/journal.pclm.0001061.pdf`). Sin línea roja ni nombre de la serie arriba.

**Encabezado (páginas 2+).** Ninguno. Solo el logo arriba.

**Pie.** Línea fina; debajo: `título breve | DOI (azul, enlace) | mes y año`, a la izquierda, 8 pt, título breve en negro; número de página en negrita a la derecha. Sin el nombre de la serie. Si falta `titulo_breve`, el pie dice «Cuaderno reproducible».

**Portada (página 1)**, de arriba abajo, ancho completo:
1. Título, bajado 1 cm (28,35 pt) bajo la banda del logo; 22 pt negrita en azul `#213362` (`heading-color`), interlineado 8,25 pt, `tracking` −0,5 pt.
2. Espacio de 30,2 pt (16 pt + 5 mm).
3. Autores, 9 pt negrita, con superíndices de afiliación (formato PLOS).
4. Afiliaciones, 7,5 pt, debajo de los autores.
5. Espacio de 40,35 pt (12 pt + 1 cm), línea fina (hairline 0,35 pt negra) y rejilla de dos columnas (319 ‰ | 22 ‰ | resto):
   - izquierda: datos de publicación, 7,5 pt y etiqueta en negrita: *Publicado*, *Contenido*, *Código*, *Identificador* (p. ej. CRC001, sale del nombre del repositorio) y *Versión* (opción `version` de la exportación Typst, p. ej. v2.0.0), y debajo el icono de Google Colab (`colab.svg`, icono simplificado) con el texto «Abrir en Colab» y enlace a la URL de la opción `colab`. **No hay caja de «Puntos clave».**
   - derecha: resumen 9,5 pt (interlineado 6,5 pt) y *Palabras clave* 8 pt separadas por « · ».
6. Debajo de la rejilla, la **caja Stack** a ancho completo y una segunda línea fina igual a la de arriba (la línea gris `---` que escribe mystmd se oculta).
7. Después, el cuaderno: aviso «Ejercicio sin validar».

**Caja Stack.** El cuaderno escribe `## Stack` y un bloque ```` ```text ````. El PDF oculta el título y el bloque en su lugar, guarda su texto (estado de Typst) y lo dibuja en la portada, bajo las palabras clave. Dibuja una caja gris `#ebebec`, radio 3 pt, relleno 8 × 7 pt, ancho completo, con «Stack» en azul, 8 pt, extrabold dentro y el texto monoespaciado pegado debajo (solo 3 pt de separación). Todo son pares «Etiqueta: valor» alineados a 23 caracteres, sin párrafos de nota; la ejecución es un renglón más: `Ejecución recomendada: Google Colab con runtime CPU`. Es el único bloque de código que se imprime; los bloques `python` y las salidas de texto sin lenguaje se omiten (están en la web).

**Títulos.** Nivel 1 en MAYÚSCULAS, 10,5 pt, y nivel 2, 9 pt (ambos extrabold azul), ancho escalado al 110 %, 23 pt antes. Nivel 1: 5,85 pt después. Nivel 2: 11,52 pt (5,85 pt + 2 mm) después, y un nivel 2 justo bajo un nivel 1 lleva también 11,52 pt antes (`style.typ` lo detecta por posición: misma página, a menos de 40 pt). **Nivel 3 (por ejemplo «2.3.1 Título»): título «corrido»,** 9 pt negrita azul, terminado en punto y en la **misma línea** que el inicio del párrafo siguiente, no debajo (estilo de los libros de texto). Se logra en `style.typ` ocultando el título, guardando su texto en un estado de Typst (`h3-pending`) y anteponiéndolo al siguiente párrafo (`show par`; la marca invisible U+2063 evita que la regla se aplique a su propia salida). Regla de redacción: escribir siempre un párrafo justo después del título de nivel 3, no una figura, tabla ni lista, porque el título se pegaría al siguiente párrafo que encuentre. El nivel de MyST que corresponde depende del documento: es el tercer nivel de títulos que aparece en el PDF (`####` en CRC001, cuyo cuaderno parte de `##`; `###` en CRC000). CRC000 incluye un ejemplo.

**Figuras.** Leyenda debajo: «**Figura N** | texto», 7,5 pt. Figuras con razón ancho/alto ≥ 2,5 salen al margen izquierdo (−72 pt) con su leyenda y nunca pasan el margen derecho.

**Tablas.** Título arriba: «**Tabla N | título**», 8,5 pt negrita bajo una línea de 0,375 pt. Cuerpo 7,5 pt, fila de encabezado gris en negrita, filas alternas claras, sin líneas entre filas, línea de cierre de 0,375 pt. Notas en 6,5 pt pegadas a la tabla. Las tablas de `tablex` (DataFrame) siguen el mismo diseño.

**Bibliografía.** Estilo APA, título «Referencias», 7,4 pt, interlineado 0,45 em.

## 4. Comportamiento de figuras y tablas (flotantes)

Figuras y tablas son **flotantes** de Typst (`place(auto, float: true)`): el motor las ubica arriba o abajo de la página donde caben y rellena el resto con texto, como hace LaTeX con `[htbp]`. Separación de 24,3 pt tras las figuras (10,1 pt + 5 mm) y de 28,2 pt tras las tablas (14 pt + 5 mm).

Con flotantes, el espacio en blanco al pie de página baja de ~1 280 pt (23 páginas) a ~145 pt (22 páginas) en CRC001. El precio: una figura o tabla puede aparecer algunas páginas después de su primera cita. Por eso el paso 6 (iteración de orden) es obligatorio.

Un flotante no se parte entre páginas: una tabla más alta que la página debe dividirse en el cuaderno o dejarse como bloque normal.

## 5. Prompt: aplicar este diseño a un cuaderno

```text
Aplica el diseño de PDF de la serie Cuadernos Reproducibles a este repositorio.
1. Copia _templates/plain-typst-article/ de cuadernos-reproducibles-crc001
   (style.typ, template.typ, template.yml, subpar-wrap.typ, logo.svg, colab.svg,
   TITULO_BREVE.md, DISENO_PDF.md), la carpeta fonts/ (STIX Two Math), los
   scripts de maquetación (medir_huecos, distancia_citas, figuras_juntas,
   buscar_maquetacion, compilar_pdf.sh) y el paso «Build PDF» del CI con
   TYPST_FONT_PATHS=${{ github.workspace }}/fonts.
2. En myst.yml, exportación typst: template ./_templates/plain-typst-article y
   titulo_breve generado con TITULO_BREVE.md a partir del título completo.
3. Verifica que existan autores con afiliación, doi, date, license y keywords.
4. En el cuaderno deja «## Stack» seguido de un bloque ```text con 5 líneas
   «Etiqueta: valor» alineadas a 23 caracteres (herramienta principal, datos base,
   escenarios, punto de análisis y «Ejecución recomendada: Google Colab con runtime CPU»).
5. Ejecuta `myst build --typst` y revisa la página 1 y una página interior.
6. Optimiza la maquetación con el procedimiento de la sección 6.
No hagas commit ni push sin que te lo pida.
```

## 6. Procedimiento: iterar el orden de objetos para maquetar mejor

Idea tomada de cómo Quarto/LaTeX compone PDF: el motor coloca flotantes donde caben y el autor reordena el texto para reducir huecos. Aquí se hace con un bucle medible.

**Medida.** `python scripts/medir_huecos.py article.pdf` imprime el hueco (pt) al pie de cada página y el total (sin la última página). Objetivo: ningún hueco > 60 pt, total mínimo, número de páginas no mayor y ninguna pareja de figuras sin texto en medio.

**Distancia a la cita.** Además del hueco, cada figura o tabla debe aparecer en la página de su primera cita o en la siguiente. Para verlo: extrae el texto por página con PyMuPDF y compara la página de «Figura N |» / «Tabla N |» con la de la primera mención sin « |».

**Regla de diseño: nunca dos figuras seguidas sin texto en medio.** Entre dos figuras de la misma página debe haber al menos un párrafo (por ejemplo, la «Lectura» de la figura anterior, como «Los días con Tmáx sobre el percentil 90 de 1985–2014 ya superan el 10 % esperado… La Figura 4 resume la distribución de los índices por periodo (ver código en la versión web).»), no solo una leyenda. Una tabla entre las dos figuras no cuenta como texto. Se verifica con `python scripts/figuras_juntas.py article.pdf` (meta: 0 parejas). Como los flotantes tienden a subirse todos al tope de la página, es la causa más común de dos figuras pegadas; se corrige con las jugadas de abajo, sobre todo moviendo la figura detrás de su párrafo de «Lectura» o bajando el ancho de una de las dos.

**Alternativa de diseño (si el procedimiento no basta):** mantener las figuras como bloques normales (sin `float`) para que el texto siempre las separe en el orden del cuaderno. Es lo que hacía la versión inicial del PDF; el precio fue ~1 280 pt de huecos en CRC001, así que solo conviene en cuadernos con pocas figuras.

**Alternativa de diseño B (figura vertical con el texto al lado).** Si una figura tiene 2 o 3 paneles horizontales (A, B, C en fila) y ocupa demasiado alto o queda pegada a otra figura, se rehace con los paneles **apilados en vertical** (una sola columna de paneles con el eje x compartido, o ejes alineados a la izquierda con la letra del panel (A), (B), (C) sobre cada uno) y se coloca en la **columna izquierda**, de ~55 % del ancho del texto, con el párrafo de «Lectura» a la **derecha**, como en los libros de texto de ciencias (ejemplo: Figure 2.10 de un capítulo de ecología marina, con la figura a la izquierda, la leyenda bajo la figura y el texto fluyendo a la derecha). Pasos:
1. En el cuaderno, regenerar la figura con `plt.subplots(n, 1, figsize=(3.2, 2.4 * n), sharex=True)` (ancho ≈ 3,2 in, alto ≈ 2,4 in por panel), letras de panel (A), (B), (C) en la esquina superior izquierda y una leyenda común.
2. Guardarla con otro nombre (`figN_vertical.png`) y usarla solo en el PDF; la web conserva la figura horizontal.
3. En Typst, componer una rejilla de dos columnas (`grid(columns: (0.55fr, 0.45fr), gutter: 14pt, figura, texto)`) con la leyenda bajo la figura, en un bloque que no se parta entre páginas.
4. Útil sobre todo para figuras con ≥ 3 paneles o cuando dos figuras seguidas no pueden separarse con texto: el párrafo de «Lectura» pasa a ser el texto lateral y cumple la regla de «nunca dos figuras seguidas sin texto».
5. Validar con `python scripts/medir_huecos.py` y revisar a mano que la figura sea legible (texto de ejes ≥ 6 pt al tamaño final). Pendiente de implementar y probar en CRC001.

**Alternativa de diseño C (párrafo a 2/3 con la figura al lado).** Para figuras pequeñas o casi cuadradas (esquemas, diagramas conceptuales, un mapa o una gráfica de un solo panel) que no necesitan el ancho completo: el párrafo que las presenta ocupa **2/3 del ancho del texto** y la figura, con su leyenda debajo, va en el **tercio restante**, alineada arriba con el párrafo (ejemplo: Figure 3.6 de un libro de ecología, con el texto a la izquierda y el esquema circular con su leyenda en negrita a la derecha). Pasos:
1. Elegir figuras con razón ancho/alto entre 0,8 y 1,3 y texto interno legible a ~1/3 del ancho (≥ 6 pt); regenerarlas con `figsize` cuadrado si hace falta.
2. Componer en Typst una rejilla `grid(columns: (2fr, 1fr), gutter: 14pt, párrafo, figura + leyenda)`; la leyenda va bajo la figura, en la misma columna, 7,5 pt con «**Figura N** |» en negrita.
3. El bloque no se parte entre páginas (`breakable: false`) y ocupa la altura del párrafo: usar párrafos de 8 a 14 líneas para que la figura quede acompañada y no queden huecos.
4. Sirve a la regla «nunca dos figuras seguidas sin texto» (el párrafo ya está al lado) y evita que figuras pequeñas floten solas arriba de la página con mucho blanco. Combinable con la alternativa B: B para figuras de varios paneles, C para figuras de un solo panel.
5. Pendiente de implementar y probar en CRC001 (candidatas: Figura 1, el flujo de seis fases, y la Figura 10, el Humidex).

**Puntuación para comparar variantes** (menor es mejor): 1 000 por cada objeto a ≥ 2 páginas de toda mención + 1 500 por cada pareja de figuras sin texto en medio + hueco total (pt) + 400 por página.

**Bucle (máximo ~8 iteraciones, un cambio por vez):**
1. Compila, mide y anota (huecos, páginas, objetos lejos de su cita).
2. Elige el peor caso: el mayor hueco o el objeto más lejano de su cita.
3. Propón UNA de estas jugadas, en el `.ipynb`/`.md` (nunca en `style.typ`, que es común a la serie):
   - mover la directiva de la figura/tabla **antes o después** del párrafo que la cita (o un párrafo más arriba/abajo);
   - intercambiar dos objetos vecinos que no dependen uno del otro;
   - cambiar el tamaño (`:width:`) de una figura entre 70 % y 100 %;
   - dividir una tabla muy alta en dos o acortar su leyenda.
4. Recompila y mide. Conserva el cambio solo si baja el hueco total o corrige un objeto lejano **sin empeorar** el otro criterio; si no, deshazlo.
5. Reglas que no se rompen: no cambiar el orden de la narración, no mover una figura antes de la primera frase que la presenta, mantener los números de figuras y tablas en orden creciente, no tocar el texto científico ni los resultados.
6. Al terminar, deja en el reporte: huecos antes/después, páginas antes/después, lista de movimientos hechos y cuáles quedan sin resolver.

Los bloques de código no importan para el PDF (se ocultan), así que mover una celda de código no cambia la maquetación; sí importa la celda que produce una figura (la salida se incrusta donde está la directiva `{figure}`).

## 7. Prompt: revisión visual final

```text
Genera el PDF, convierte las páginas a imagen (pdftoppm -r 70) y revisa: logo sin
solapes; portada sin huecos anómalos; Stack completo en la página 1; ninguna
figura/tabla cortada; leyendas legibles; ecuaciones sin caracteres solapados;
pie con título breve | DOI | fecha. Lista cada hallazgo con página y propuesta.
```

## 8. Trampas conocidas

- Compilar con `myst build --typst` a secas funciona, pero solo usa STIX Two Math si está instalada en el sistema; para que sea idéntico al CI usa `sh scripts/compilar_pdf.sh` (define `TYPST_FONT_PATHS`). Si un repositorio nuevo no tiene la carpeta `fonts/`, cópiala de CRC001.
- Liberation Sans (texto) sigue instalándose en el CI con `apt` (`fonts-liberation`); si algún día falla, también puede ir en `fonts/`.
- Los reemplazos en `style.typ` fallan en silencio si no coincide la sangría (usa tabuladores).
- Una `show heading` que oculta el título de Stack debe declararse **después** de las reglas por nivel, o deja el espacio del título vacío.
- En `template.yml` hay que listar `logo.svg` en `files`, o mystmd no lo copia a la compilación.
- `myst.yml` con `jupyter: true` ejecuta los cuadernos al compilar (CRC000); con `jupyter: false` usa las salidas guardadas (CRC001).
- Compilar requiere `typst` y mystmd ≥ 1.13 con Node ≥ 22.
