"""Distancia (en páginas) entre cada figura/tabla y la mención más cercana en el texto.

Uso: python scripts/distancia_citas.py article.pdf
Usa la mención más cercana (no la primera, que puede ser una referencia anticipada
en la metodología). Marca con <-- los objetos a 2 o más páginas de toda mención. Complementa a medir_huecos.py (ver DISENO_PDF.md, sección 6).
"""
import re, sys
import fitz

doc = fitz.open(sys.argv[1])
cap, cite = {}, {}
for i, p in enumerate(doc, 1):
    t = p.get_text()
    for m in re.finditer(r"(Figura|Tabla) (\d+) \|", t):
        cap.setdefault((m[1], int(m[2])), i)
    for m in re.finditer(r"(Figura|Tabla) (\d+)(?! \|)", t):
        cite.setdefault((m[1], int(m[2])), []).append(i)
lejos = 0
for k in sorted(cap, key=lambda x: (x[0] != "Figura", x[1])):
    c = cite.get(k, [])
    d = min((abs(cap[k] - x) for x in c), default=None)
    flag = "  <--" if d is not None and d >= 2 else ""
    lejos += bool(flag)
    print(f"{k[0]} {k[1]:2d}: menciones en pág {c} -> aparece pág {cap[k]}{flag}")
print(f"\nobjetos lejos de toda mención: {lejos}")
