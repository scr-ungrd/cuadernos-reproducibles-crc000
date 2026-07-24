# Plantilla de Envío MyST

[![Hecho con MyST](https://img.shields.io/badge/made%20with-myst-orange)](https://mystmd.org)

Esta plantilla de envío es para una publicación basada en markdown con archivos adicionales de cuadernos y markdown de apoyo, así como datos, bibliografía y configuración de compilación de MyST.

## Archivos fuente

El archivo fuente principal de esta plantilla es un artículo en markdown de MyST. Este archivo puede hacer referencia a celdas de cuadernos de otros subartículos para usar la salida de esas celdas como figuras. También puede hacer referencia a contenido de otros subartículos en markdown. Todos estos cuadernos/artículos fuente complementarios deben guardarse en la carpeta `notebooks/`. También contiene bloques de MyST etiquetados en sus metadatos como `"part": "abstract"`, o `"part": "availability"` - estas celdas se extraerán del documento y se incluirán como la parte especificada en la salida generada.

## Material de apoyo

### Datos complementarios

Por convención, todos los datos deben guardarse en el directorio `data/`. No hay nada especial en este directorio; las referencias a tus datos desde tu cuaderno deben seguir especificando la ruta relativa correcta.

### Imágenes complementarias

De manera similar al directorio `data/`, las imágenes para las figuras deben especificarse en el directorio `images/`.

### Bibliografía

Las entradas bibliográficas pueden especificarse de dos maneras, ambas descritas en la [documentación de MyST](https://mystmd.org/guide/citations). Pueden listarse explícitamente en formato BibTeX, por convención en el archivo `references.bib`, y referenciarse por clave usando un rol `cite` de MyST. También pueden especificarse como enlaces DOI en línea. Estos no requieren información bibliográfica completa; los datos se obtienen implícitamente al compilar a partir del DOI.

## Configuración de MyST

Se debe proporcionar un archivo `myst.yml` para configurar los metadatos y las exportaciones del cuaderno. Esto incluye autores, afiliaciones, licencias, palabras clave y [mucho más](https://mystmd.org/guide/frontmatter).

## Compilación de artefactos de salida

Para compilar la salida en PDF/JATS a partir de tus datos fuente, debes tener instalado el CLI de MyST Markdown

```bash
npm install -g mystmd
```

Luego compila todas las exportaciones definidas en el archivo `myst.yml`:

```bash
myst build --all
```
