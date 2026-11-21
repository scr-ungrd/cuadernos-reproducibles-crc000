// Plain academic article style (unbranded).
//
// Adapted from the "cellpress-unofficial" Typst template by Robin Eklind
// (https://github.com/mewmew/cellpress-unofficial, 0BSD license). The Cell
// Press logo and fixed journal branding (Elsevier/Cell Press trademarks)
// have been removed so this can be used as a generic, unbranded article
// layout.
//
// Page design: accent bar on top of every page, running header, footer with
// page number, sans-serif text throughout (Liberation Sans) and a single
// accent colour (links keep their own blue).

// Font. "Liberation Sans" is installed explicitly in CI (fonts-liberation) so
// the PDF renders the same locally and on GitHub Actions.
#let font-sans-serif = "Liberation Sans"

// Colours: one accent (bar, rules, headings), one link colour, neutral greys.
#let accent       = rgb("#0a2f5c")
#let link-blue    = rgb("#0296d3")
#let neutral-gray = luma(45%)
#let rule-gray    = luma(80%)
#let heading-color  = rgb("#213362") // section headings
#let header-fill  = luma(87%) // table header row
#let zebra-fill   = luma(94%) // alternate table rows
#let dark-rule    = luma(15%) // heavy rules of tables
#let code-fill    = rgb("#f1f4f9") // soft tint of the accent, for code cells

// mystmd's LaTeX-to-Typst math converter emits the bare identifier `diff`
// for \partial, which is not a builtin symbol in current Typst releases.
// Shim it so partial-derivative equations compile.
#let diff = "∂"

// --- [ tables ] --------------------------------------------------------------

#let toprule(color: accent) = {
	table.hline(stroke: 0.7pt + color)
}

#let bottomrule(color: accent) = {
	table.hline(stroke: 0.7pt + color)
}

#let midrule(color: accent) = {
	table.hline(stroke: 0.5pt + color)
}

#let tabsubhdr(content, colspan: 3, color: accent) = table.header(
	level: 2,
	table.cell(
		colspan: colspan,
		inset: (y: 5pt),
		fill: none,
		{
			set text(fill: color)
			show text: emph
			content
		}
	)
)

// Table design (after Nature Reviews "Table 3"): a thin rule above the bold
// caption, grey header row in bold, alternate rows in light grey with no lines
// between rows, top-aligned small sans-serif text and a thin closing rule.
// The caption itself is styled by the generic `figure.caption` rule in
// `template` (shared with figures).
#let style-table(body) = {
	// mystmd emits captioned tables as `figure(kind: "table")` (a string), Typst's
	// own tables as `kind: table`; handle both.
	show figure.where(kind: "table"): set figure.caption(position: top)
	show figure.where(kind: table): set figure.caption(position: top)
	show figure.where(kind: "table"): set block(breakable: true, above: 14pt, below: 14pt + 14.2pt)
	// Table, title and legend are left-aligned (a figure centers its body).
	show figure.where(kind: "table"): it => {
		show align: a => if a.alignment == left { a } else { align(left, a.body) }
		it
	}
	show figure.where(kind: table): set block(breakable: true, above: 14pt, below: 14pt + 14.2pt)
	show table: set table(
		columns: 1fr,
		align: left + top,
		fill: (_, y) => if y == 0 { header-fill } else if calc.even(y) { zebra-fill },
		stroke: none,
		inset: (x: 5pt, y: 4pt),
	)
	show table: set text(font: font-sans-serif, size: 7.5pt)
	show table: set par(justify: false)
	show table.cell.where(y: 0): set text(weight: "bold")
	show table: it => block(
		width: 100%,
		stroke: (bottom: 0.375pt + dark-rule),
		// Inset keeps the cell fills from painting over the closing rule.
		inset: (bottom: 1pt),
		it,
	)

	body
}

// Legend (notes) under a table, like the notes of a Nature table: small and
// plain. mystmd emits it as `text(..legendStyle)[...]` below the table.
#let legendStyle = (size: 6.5pt, fill: black, style: "normal")

// Same table design for tables that mystmd emits through `tablex` (named
// arguments spread into every `tablex(...)` call by the generated document).
#let tableStyle = (
	width: 100%,
	align: left + top,
	inset: (x: 5pt, y: 4pt),
	auto-lines: false,
)

// Completes the arguments of a `tablex(...)` call: equal-width columns so the
// table spans the text width, and header/zebra fills and bold header text that
// respect the number of header rows (`header-rows`).
#let tablex-args(named) = {
	let named = named
	let cols = named.at("columns", default: none)
	if type(cols) == int { named.insert("columns", (1fr,) * cols) }
	let hr = named.at("header-rows", default: 1)
	named.insert("fill", (_, row) => if row < hr { header-fill } else if calc.odd(row - hr) { zebra-fill })
	named.insert("map-rows", (row, cells) => cells.map(c => if c == none { c } else if row < hr {
		(..c, content: strong(c.content))
	} else { c }))
	named
}

// Wraps a `tablex` call: small sans-serif text and a thin closing rule.
#let wrap-table(tbl) = {
	set text(font: font-sans-serif, size: 7.5pt)
	set par(justify: false)
	block(
		width: 100%,
		above: 1em,
		below: 1em,
		stroke: (bottom: 0.375pt + dark-rule),
		inset: (bottom: 1pt),
		tbl,
	)
}

// --- [ template ] ------------------------------------------------------------

// Horizontal page margins and the resulting text width.
// Proportions of the text block of page 2 of an Annual Reviews article
// (left 18.3 %, right 8.5 % of the page width), used on every page.
#let margin-left  = 112pt
#let margin-right = 52pt + 14.17pt // 52 pt + 5 mm
#let text-width   = 8.5in - margin-left - margin-right

// The page design follows the layout of a Nature Climate Change article
// (all vertical distances in pt, measured on that PDF): accent bar, journal
// masthead, "article type + DOI" row between hairlines, title, two-column
// front matter (metadata rows | authors + abstract), affiliations above the
// footer on page 1, and a "label + DOI" running header on later pages.
#let hairline = 0.35pt + black

#let months-es = ("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")
#let fmt-date(d) = str(d.day) + " de " + months-es.at(d.month - 1) + " de " + str(d.year)
#let fmt-month-year(d) = months-es.at(d.month - 1) + " de " + str(d.year)

// Authors with superscript affiliation numbers, e.g. "A. Autor¹, B. Autora¹ˑ²".
#let author-line(authors, affiliations) = {
	let ids = affiliations.map(a => a.id)
	authors.map(a => {
		let idx = a.affs.map(id => str(ids.position(x => x == id) + 1))
		a.name
		if idx.len() > 0 { super(idx.join(",")) }
	}).join(", ", last: " y ")
}

// "¹Institution, department, city, country. ²…" for the footnote of page 1.
#let affiliation-text(affiliations) = affiliations.enumerate().map(((i, a)) => {
	let parts = (a.name, a.department, a.city, a.country).filter(x => x != "")
	super(str(i + 1)) + parts.join(", ") + "."
}).join(" ")

// Key points: list inside a box with the grey background of the "Highlights" box of a Cell Press article.
#let keypoints-fill = rgb("#ebebec")
#let keypoints-box(title: "Puntos clave", body) = block(
	width: 100%,
	fill: keypoints-fill,
	radius: 3pt,
	inset: (x: 8pt, y: 7pt),
	{
		set par(justify: false)
		set list(indent: 0pt, body-indent: 4pt, spacing: 0.7em)
		text(size: 8pt, weight: "extrabold", fill: heading-color)[#title]
		v(6pt)
		set text(size: 7.5pt)
		body
	},
)

#let print-doi(doi, size: 8pt) = {
	set text(font: font-sans-serif, size: size, fill: link-blue)
	link("https://doi.org/" + doi)
}

// Logo of the series, drawn on the page background of every page at the
// top-left corner (as the journal logo of a PLOS article: hanging in the left
// margin, above the text block).
#let logo-x = 36pt
#let logo-y = 12pt
#let logo-w = 170pt
#let page-logo() = place(top + left, dx: logo-x, dy: logo-y, image("logo.svg", width: logo-w))

// Pages 2+ have no running header (the logo of the page background is the only element on top).
#let print-header(supertitle, doi) = none

// Footer: hairline, "journal | DOI (link) | date" on the left, bold page number on the right.
#let print-footer(supertitle, doi, date) = {
	set text(font: font-sans-serif, size: 8pt)
	set block(spacing: 0pt)
	line(length: 100%, stroke: hairline)
	v(7pt)
	// Running head of the article (black), then DOI and date, separated by |.
	let parts = ()
	if supertitle != none { parts.push(text(fill: black)[#supertitle]) }
	if doi != none {
		parts.push(text(fill: link-blue, link("https://doi.org/" + doi)))
	}
	if date != none { parts.push(fmt-month-year(date)) }
	grid(
		columns: (1fr, auto),
		align: (left, right),
		parts.join([ | ]),
		strong(context counter(page).display()),
	)
}

#let h3-pending = state("h3-pending", none)

// Stack box: text captured from the document (the ```text block under "## Stack"),
// drawn on the front page under the keywords. Same design as the former key-points
// box: grey background, bold title inside, monospace text right under it.
#let stack-text = state("stack-text", none)
#let stack-box() = context {
	let txt = stack-text.final()
	if txt != none {
		block(
			width: 100%,
			fill: keypoints-fill,
			radius: 3pt,
			inset: (x: 8pt, y: 7pt),
			breakable: false,
			{
				set par(justify: false)
				set block(spacing: 0pt)
				text(font: font-sans-serif, size: 8pt, weight: "extrabold", fill: heading-color)[Stack]
				v(3pt)
				raw(txt, block: true, lang: "stack")
			},
		)
	}
}

// front-page places the page-1 front matter: title, authors with their
// affiliations right below (as in PLOS), then two columns (key points + publication
// data | abstract + keywords).
#let front-page(
	title:           "",
	authors:         (),
	affiliations:    (),
	date:            none,
	license-content: none,
	license-code:    none,
	abstract:        none,
	keywords:        (),
	keypoints:       none,
	report-id:       none,
	version:         none,
	colab:           none,
	..args,
) = {
	let left-w = 0.319 * text-width
	let gutter = 0.022 * text-width

	place(top + left, float: true, scope: "parent", clearance: 16pt)[
		#set par(justify: false)
		#set block(spacing: 0pt)
		#v(28.35pt) // 1 cm below the logo band
		#block(width: 100%, {
			set text(font: font-sans-serif, size: 22pt, weight: "bold", tracking: -0.5pt, fill: heading-color)
			set par(leading: 8.25pt)
			title
		})
		// Authors and, right under them, their affiliations (as in PLOS Climate).
		#v(16pt + 14.2pt) // +5 mm after the title
		#text(size: 9pt, weight: "bold")[#author-line(authors, affiliations)]
		#v(7pt)
		#block(width: 100%, text(size: 7.5pt)[#affiliation-text(affiliations)])
		#v(12pt + 28.35pt) // +1 cm before the abstract and key points
		#line(length: 100%, stroke: hairline)
		#grid(
			columns: (left-w, gutter, 1fr),
			{
				v(9pt)
				// Publication data, PLOS style: bold label followed by the value.
				v(12pt)
				{
					set text(size: 7.5pt)
					set par(justify: false, leading: 0.5em)
					if date != none [*Publicado:* #fmt-date(date)]
					if license-content != none [\ *Contenido:* #license-content]
					if license-code != none [\ *Código:* #license-code]
					if report-id != none [\ *Identificador:* #report-id]
					if version != none [\ *Versión:* #version]
					if colab != none {
						linebreak()
						link(colab, box(baseline: 20%, image("colab.svg", height: 9pt)) + h(3pt) + text(fill: link-blue)[Abrir en Colab])
					}
				}
			},
			[],
			{
				v(5.3pt)
				if abstract != none {
					set text(size: 9.5pt)
					set par(leading: 6.5pt)
					abstract
				}
				if keywords.len() > 0 {
					v(8pt)
					text(size: 8pt)[*Palabras clave:* #keywords.join(" · ")]
				}
			},
		)
		#v(10pt)
		#stack-box()
		#v(10pt)
		#line(length: 100%, stroke: hairline)
	]
}

// template applies the article format to the document: page geometry,
// masthead / header / footer, and the text, caption, code and heading styles.
#let template(
	journal:      none,
	supertitle:   "Cuaderno reproducible",
	report-id:    none,
	title:        "Paper Title",
	authors:      (),
	affiliations: (),
	doi:          none,
	date:         none,
	github:       none,
	..args,
	body
) = {
	// PDF metadata (title, authors, keywords, date): read by viewers, search engines and
	// reference managers.
	set document(
		title: title,
		author: authors.map(a => a.name),
		keywords: args.named().at("keywords", default: ()),
		date: if date != none { datetime(year: date.year, month: date.month, day: date.day, hour: 12, minute: 0, second: 0) } else { auto },
	)

	set page(
		width: 8.5in,
		height: 11in,
		margin: (
			left: margin-left,
			right: margin-right,
			top: 80pt,
			bottom: 93.19pt, // 45 pt + 1 cm + 7 mm de aire sobre el pie
		),
		columns: 1,
		background: context {
			page-logo()
		},
		header: print-header(supertitle, doi),
		header-ascent: 11pt,
		footer: print-footer(supertitle, doi, date),
		footer-descent: 56.79pt, // deja la línea del pie en su sitio (8,6 pt + 1 cm + 7 mm)
	)
	set par(justify: true)
	set text(font: font-sans-serif, size: 8.4pt, lang: "es")

	// mystmd writes the "---" of the notebook as a grey line: the front page draws its own.
	show line: it => if it.stroke.paint == gray { none } else { it }

	// Equations: STIX Two Math (sturdier strokes, closer to the sans text than the default
	// New Computer Modern Math); falls back to the default font if it is not installed.
	show math.equation: set text(font: ("STIX Two Math", "New Computer Modern Math"))

	show ref: set text(fill: link-blue)
	show link: set text(fill: link-blue)
	show cite: set text(fill: link-blue)
	show footnote: set text(fill: link-blue)

	show: style-table

	// Captions for figures and tables: "Figura 1 | text" / "Tabla 1 | text",
	// sans-serif, small, left-aligned, only the label in bold.
	show figure.caption: it => {
		set align(left)
		if it.kind == table or it.kind == "table" {
			// Table titles: bold, one block under a thin rule (like Nature "Table 3").
			set text(font: font-sans-serif, size: 8.5pt, weight: "bold")
			set par(leading: 0.45em, justify: false)
			block(
				width: 100%,
				above: 6pt,
				below: 6pt,
				stroke: (top: 0.375pt + dark-rule),
				inset: (top: 5pt),
			)[
				Tabla #context it.counter.display(it.numbering)#h(0.3em)|#h(0.3em)#it.body
			]
		} else {
			set text(font: font-sans-serif, size: 7.5pt)
			set par(leading: 0.5em)
			let label = if it.kind == image or it.kind == "figure" { [Figura] } else { it.supplement }
			block(width: 100%, above: 6pt, below: 6pt)[
				#strong[#label #context it.counter.display(it.numbering)]#h(0.3em)|#h(0.3em)#it.body
			]
		}
	}

	// Very wide figures (aspect ratio >= 2.5) break out of the text block, left
	// into the margin and a little to the right, and their caption goes with them
	// (as the wide figures of Reviews of Geophysics).
	// 5 mm (14.2 pt) of extra space after the caption of every figure and table.
	show figure: it => if it.kind == table or it.kind == "table" {
		place(auto, float: true, clearance: 14pt + 14.2pt, it)
	} else if it.kind != image and it.kind != "figure" { it } else {
		place(auto, float: true, clearance: 10.1pt + 14.2pt, layout(size => {
			let m = measure(block(width: size.width, it.body))
			if m.width / m.height >= 2.5 {
				pad(left: -(margin-left - 40pt), it)
			} else { it }
		}))
	}

	// Compact bibliography, one point smaller than the text.
	show bibliography: set text(size: 7.4pt)
	show bibliography: set par(leading: 0.45em, spacing: 0.55em)

	// Other fenced blocks (e.g. the Stack box, lang "text") get a soft tinted
	// background and no side bar.
	show raw.where(block: true): it => if it.lang == "python" or it.lang == none {
		// The PDF omits the code cells (lang "python") and their text outputs
		// (no lang); both are available in the web version.
		none
	} else if it.lang == "text" {
		// The Stack block is not printed here: its text is kept and drawn by the
		// front page, under the keywords (see `stack-box`).
		stack-text.update(it.text)
		none
	} else {
		it
	}

		// The Stack box carries its own title: hide the heading (declared last so it runs first).
	// All headings use the sans-serif face. Levels 1 and 2: 23 pt above and 5.85 pt
	// below (half of the former 11.7 pt).
	show heading: set text(font: font-sans-serif)
	show heading.where(level: 1): it => {
		set text(size: 10.5pt, weight: "extrabold", tracking: -0.2pt, fill: heading-color)
		set block(above: 23pt, below: 5.85pt)
		scale(origin: left+horizon, x: 110%)[#upper(it)]
	}
	// A level 2 heading that comes right after a level 1 heading (same page, less
	// than 40 pt below it) is pulled up to 11.52 pt (5.85 pt + 2 mm) instead of 23 pt.
	show heading.where(level: 2): it => context {
		let prev = query(heading.where(level: 1).before(here(), inclusive: false))
		let adjacent = if prev.len() == 0 { false } else {
			let a = prev.last().location().position()
			let b = here().position()
			a.page == b.page and b.y - a.y < 40pt
		}
		set text(size: 9pt, weight: "extrabold", tracking: -0.2pt, fill: heading-color)
		block(above: if adjacent { 11.52pt } else { 23pt }, below: 11.52pt, sticky: true, scale(origin: left+horizon, x: 110%)[#it])
	}
	// Level 3 headings (e.g. "2.3.1 Title") are run-in: the title goes in bold on the
	// same line as the first words of the paragraph that follows, ending with a period.
	// The heading is hidden and its text is kept in a state; the next paragraph picks it
	// up (the invisible mark U+2063 prevents the rule from matching its own output).
	show heading.where(level: 3): it => { h3-pending.update(it.body); none }
	show par: it => context {
		let kids = if it.body.has("children") { it.body.children } else { (it.body,) }
		let done = kids.len() > 0 and kids.first().has("text") and kids.first().text == "\u{2063}"
		let pending = h3-pending.get()
		if pending != none and not done {
			h3-pending.update(none)
			par([#"\u{2063}"] + text(weight: "bold", size: 9pt, fill: heading-color)[#pending.] + h(0.5em) + it.body)
		} else { it }
	}
	// The Stack box carries its own title: hide the heading (declared last so it runs first).
	show heading: it => if it.body == [Stack] { none } else { it }

	body
}
