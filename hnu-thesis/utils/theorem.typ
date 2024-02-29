#import "@preview/ctheorems:1.1.1": *
#show: thmrules // 添加定理环境
#set heading(numbering: "1.1.")

#let theorem = thmbox("theorem", "定理", inset: (x: 1.2em, top: 1em))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 2.2em, top: 1em))

#let example = thmplain("example", "示例").with(numbering: none)
#let proof = thmplain(
  "proof",
  "证明",
  base: "theorem",
  bodyfmt: body => [#body #h(1fr) $square$]
).with(numbering: none)

#let proposition = thmbox("proposition", "命题", inset: (x: 1.2em, top: 1em))