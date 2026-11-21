"""Búsqueda automática de una mejor maquetación del PDF moviendo figuras/tablas.

Uso (desde la raíz del repositorio, con el PDF ya compilable):
    python scripts/buscar_maquetacion.py [cuaderno.ipynb] [--ancho]

Prueba mover cada figura o tabla problemática unas celdas arriba o abajo
(modo por defecto) o cambiar el ancho de las figuras a 90/80/70 % (--ancho),
recompila con `myst build --typst` y conserva solo los cambios que bajan la
puntuación (ver DISENO_PDF.md, sección 6):
    1 000 por objeto a >= 2 páginas de toda mención
  + 1 500 por pareja de figuras sin texto en medio
  + hueco total al pie (pt) + 400 por página.
Nunca cambia el orden relativo de figuras ni de tablas (los números se mantienen).
Hace una copia `<cuaderno>.antes_busqueda` antes de empezar y escribe el mejor
resultado en el propio cuaderno. Solo funciona con cuadernos .ipynb (en un
article.md hay que mover los bloques a mano).
"""
import copy, json, re, subprocess, sys
import fitz
sys.path.insert(0, "scripts")
from figuras_juntas import parejas
from medir_huecos import BODY_TOP, BODY_BOTTOM

NB = next((a for a in sys.argv[1:] if a.endswith(".ipynb")), "article.ipynb")
MODO_ANCHO = "--ancho" in sys.argv
PDF = "article.pdf"

def build():
    subprocess.run(["myst", "build", "--typst"], capture_output=True)

def load():
    return json.load(open(NB))

def save(nb):
    json.dump(nb, open(NB, "w"), ensure_ascii=False, indent=1)
    open(NB, "a").write("\n")

def label(c):
    m = re.search(r":label: ((?:fig|tbl)-[\w-]+)", "".join(c["source"]))
    return m[1] if m and c["cell_type"] == "markdown" else None

def units(nb):
    """etiqueta -> (índice inicial, nº de celdas); una tabla incluye su celda de código previa."""
    out = {}
    for i, c in enumerate(nb["cells"]):
        l = label(c)
        if l:
            s = i - 1 if l.startswith("tbl") and i > 0 and nb["cells"][i - 1]["cell_type"] == "code" else i
            out[l] = (s, i - s + 1)
    return out

def orden_etiquetas(nb):
    return [label(c) for c in nb["cells"] if label(c)]

def score():
    d = fitz.open(PDF)
    n = len(d)
    def hueco(p):
        bs = [b[3] for b in p.get_text("blocks") if BODY_TOP < b[1] and b[3] <= BODY_BOTTOM + 2]
        bs += [fitz.Rect(i["bbox"]).y1 for i in p.get_image_info()
               if i["bbox"][1] > BODY_TOP and fitz.Rect(i["bbox"]).y1 <= BODY_BOTTOM + 2]
        bs += [x["rect"].y1 for x in p.get_drawings()
               if x["rect"].y0 > BODY_TOP and x["rect"].y1 <= BODY_BOTTOM + 2 and x["rect"].width > 2]
        return max(0.0, BODY_BOTTOM - max(bs)) if bs else BODY_BOTTOM - BODY_TOP
    gaps = [hueco(p) for p in d][:-1]
    cap, cite = {}, {}
    for i, p in enumerate(d, 1):
        t = p.get_text()
        for m in re.finditer(r"(Figura|Tabla) (\d+) \|", t):
            cap.setdefault((m[1], int(m[2])), i)
        for m in re.finditer(r"(Figura|Tabla) (\d+)(?! \|)", t):
            cite.setdefault((m[1], int(m[2])), []).append(i)
    lejos = [k for k in cap if cite.get(k) and min(abs(cap[k] - c) for c in cite[k]) >= 2]
    pj = parejas(d)
    return (len(lejos) * 1000 + len(pj) * 1500 + sum(gaps) + n * 400,
            lejos + [("juntas",) + x for x in pj], round(sum(gaps)), n)

def objetos_problema(nb, malos):
    objs = []
    for k in malos:
        objs += [("Figura", k[2]), ("Figura", k[3])] if k[0] == "juntas" else [k]
    labs = []
    ordenado = sorted(units(nb).items(), key=lambda x: x[1][0])
    for tipo, num in dict.fromkeys(objs):
        pref = "fig" if tipo == "Figura" else "tbl"
        etiquetas = [l for l, _ in ordenado if l.startswith(pref)]
        labs.append(etiquetas[num - 1])
    return labs

def mover(nb, lab, delta):
    s, n = units(nb)[lab]
    cells = nb["cells"]
    bloque, resto = cells[s:s + n], cells[:s] + cells[s + n:]
    pos = max(1, min(len(resto), s + delta))
    nb["cells"] = resto[:pos] + bloque + resto[pos:]
    return nb

def poner_ancho(nb, lab, w):
    for c in nb["cells"]:
        if label(c) == lab:
            for k, l in enumerate(c["source"]):
                if l.startswith(":width:"):
                    c["source"][k] = f":width: {w}%\n"
                    return True
            for k, l in enumerate(c["source"]):
                if l.startswith(":label:"):
                    c["source"].insert(k + 1, f":width: {w}%\n")
                    return True
    return False

def main():
    open(NB + ".antes_busqueda", "w").write(open(NB).read())
    mejor_nb = load()
    orden0 = orden_etiquetas(mejor_nb)
    build()
    mejor = score()
    print("inicio", mejor, flush=True)
    for ronda in range(2):
        mejora = False
        if MODO_ANCHO:
            labs = [l for l in units(mejor_nb) if l.startswith("fig")]
        else:
            labs = objetos_problema(mejor_nb, mejor[1])
        for lab in labs:
            opciones = [("ancho", w) for w in (90, 80, 70)] if MODO_ANCHO else [("mover", d) for d in (-4, -3, -2, -1, 1, 2, 3, 4)]
            for tipo, val in opciones:
                nb = copy.deepcopy(mejor_nb)
                ok = poner_ancho(nb, lab, val) if tipo == "ancho" else (mover(nb, lab, val) is not None)
                if not ok or orden_etiquetas(nb) != orden0:
                    continue
                save(nb)
                build()
                sc = score()
                if sc[0] < mejor[0]:
                    mejor, mejor_nb, mejora = sc, copy.deepcopy(nb), True
                    print(ronda, lab, tipo, val, sc, flush=True)
        save(mejor_nb)
        if not mejora:
            break
    save(mejor_nb)
    build()
    print("final", score())

if __name__ == "__main__":
    main()
