"""Mide el espacio en blanco al pie de cada página del PDF (maquetación).

Uso:  python scripts/medir_huecos.py article.pdf [--max 60]

Para cada página calcula el hueco entre el último contenido del cuerpo (texto,
imágenes o dibujos vectoriales) y el borde inferior del bloque de texto.
Imprime una tabla y el resumen: huecos totales (pt), páginas con hueco mayor
que --max (pt) y número de páginas. Menos es mejor. Sirve para comparar
variantes de orden de figuras/tablas (ver DISENO_PDF.md, sección 6).
"""
import sys
import fitz  # PyMuPDF

BODY_TOP, BODY_BOTTOM = 76.0, 698.81  # pt; cuerpo de la página carta (margen sup. 80, inf. 93,19)

def hueco(page):
    bottoms = []
    for b in page.get_text("blocks"):
        if BODY_TOP < b[1] and b[3] <= BODY_BOTTOM + 2:
            bottoms.append(b[3])
    for im in page.get_image_info():
        r = fitz.Rect(im["bbox"])
        if r.y0 > BODY_TOP and r.y1 <= BODY_BOTTOM + 2:
            bottoms.append(r.y1)
    for d in page.get_drawings():
        r = d["rect"]
        if r.y0 > BODY_TOP and r.y1 <= BODY_BOTTOM + 2 and r.width > 2:
            bottoms.append(r.y1)
    return max(0.0, BODY_BOTTOM - max(bottoms)) if bottoms else BODY_BOTTOM - BODY_TOP

def main():
    path = sys.argv[1]
    lim = float(sys.argv[sys.argv.index("--max") + 1]) if "--max" in sys.argv else 60.0
    doc = fitz.open(path)
    gaps = [hueco(p) for p in doc]
    for i, g in enumerate(gaps, 1):
        print(f"pág {i:2d}: hueco {g:5.0f} pt {'#' * int(g // 10)}{'  <--' if g > lim and i < len(gaps) else ''}")
    # la última página puede quedar corta: no cuenta
    body = gaps[:-1]
    print(f"\npáginas: {len(gaps)} | hueco total (sin la última): {sum(body):.0f} pt "
          f"| páginas con hueco > {lim:.0f} pt: {sum(g > lim for g in body)}")

if __name__ == "__main__":
    main()
