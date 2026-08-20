// Included verbatim by pandoc (--include-in-header) ahead of the document
// content, which pandoc then wraps in its `conf` template function.
// Only `show` rules and `set` rules for properties `conf` does not itself
// set belong here - anything conf sets (page, margin, fontsize, par leading)
// has to come from render/meta.yaml instead, because conf is applied inside.

#let cvlink = rgb("#0B5394")
#show link: set text(fill: cvlink)

// conf sets par justify + leading, but not the gap between paragraphs.
#set par(spacing: 0.85em)

// Tight bullet lists.
#set list(indent: 0.4em, body-indent: 0.5em, spacing: 0.6em)

// Section headings: centred, letterspaced caps over a hairline rule.
#show heading.where(level: 1): it => block(width: 100%, above: 1.6em, below: 0.9em, breakable: false)[
  #align(center)[#text(size: 1.1em, weight: "bold", tracking: 0.6pt)[#upper(it.body)]]
  #v(0.35em, weak: true)
  #line(length: 100%, stroke: 0.6pt + luma(40%))
]

// One work / education entry header, e.g.
//   Employer <------ fill ------> Role  Dates
// A wider gap above than below binds the header to the prose beneath it
// rather than leaving it floating between two entries. width: 100% matters:
// a bare block shrinks to fit its content, leaving h(1fr) nothing to fill.
#let entry(body) = block(width: 100%, above: 1.15em, below: 0.4em, body)

// Repo link, pinned to the bottom of the last page: v(1fr) soaks up whatever
// vertical space is left in the page flow.
#let source-link(url) = {
  v(1fr)
  align(center)[
    #line(length: 30%, stroke: 0.4pt + luma(50%))
    #v(0.6em, weak: true)
    #text(size: 8.5pt)[Source and latest version: #link(url)]
  ]
}
