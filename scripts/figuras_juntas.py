"""Detecta figuras consecutivas sin un párrafo de texto en medio.

Uso: python scripts/figuras_juntas.py article.pdf

Regla de diseño (DISENO_PDF.md, sección 6): entre dos figuras que aparecen en la
misma página debe haber al menos un párrafo de texto (por ejemplo, la «Lectura»
de la figura anterior), no solo una leyenda. Cuenta como párrafo un bloque de
texto de 3 o más líneas que no sea leyenda ni título de tabla. Una tabla entre
dos figuras no cuenta como texto.
Imprime las parejas que incumplen la regla y el total.
"""
import re, sys
import fitz

TOP, BOTTOM = 76.0, 700.0

def parejas(doc):
    """Lista de (página, figura_a, figura_b) que incumplen la regla."""
    out = []
    for n, page in enumerate(doc, 1):
        figs = []  # (y0, y1, número) de cada figura (imagen + leyenda) de la página
        for b in page.get_text("blocks"):
            m = re.match(r"\s*Figura (\d+) \|", b[4])
            if m:
                figs.append(int(m[1]))
        if len(figs) < 2:
            continue
        # posición vertical de cada figura: su leyenda; el cuerpo de la figura está encima
        caps = {}
        for b in page.get_text("blocks"):
            m = re.match(r"\s*Figura (\d+) \|", b[4])
            if m:
                caps[int(m[1])] = (b[1], b[3])
        paras = []
        for b in page.get_text("blocks"):
            t = b[4].strip()
            if TOP < b[1] and b[3] < BOTTOM and not re.match(r"(Figura|Tabla) \d+ \|", t):
                nlin = t.count("\n") + 1
                if nlin >= 3 and (b[3] - b[1]) > 22 and "Tmáx_" not in t[:0]:
                    paras.append((b[1], b[3]))
        orden = sorted(caps.items(), key=lambda kv: kv[1][0])
        for (a, (ay0, ay1)), (c, (cy0, cy1)) in zip(orden, orden[1:]):
            # el cuerpo de la figura c empieza por encima de su leyenda; usamos las imágenes
            imgs = [fitz.Rect(i["bbox"]) for i in page.get_image_info() if i["bbox"][1] > TOP]
            tops = [r.y0 for r in imgs if r.y1 <= cy0 + 2 and r.y0 >= ay1 - 2]
            top_c = min(tops) if tops else cy0
            hay = any(p0 >= ay1 - 2 and p1 <= top_c + 2 for p0, p1 in paras)
            if not hay:
                out.append((n, a, c))
    return out

def main():
    malas = parejas(fitz.open(sys.argv[1]))
    for n, a, c in malas:
        print(f"pág {n}: Figura {a} y Figura {c} sin párrafo entre ellas")
    print(f"\nparejas de figuras sin texto en medio: {len(malas)}")

if __name__ == "__main__":
    main()
