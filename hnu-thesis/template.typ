#import "@preview/anti-matter:0.0.2": anti-inner-end as mainmatter-end
#import "layouts/doc.typ": doc
#import "layouts/preface.typ": preface
#import "layouts/mainmatter.typ": mainmatter
#import "layouts/appendix.typ": appendix
#import "templates/master-cover.typ": master-cover
#import "templates/master-decl-page.typ": master-decl-page
#import "templates/master-abstract.typ": master-abstract
#import "templates/master-abstract-en.typ": master-abstract-en
#import "templates/bachelor-outline-page.typ": bachelor-outline-page
#import "templates/notation.typ": notation
#import "templates/acknowledgement.typ": acknowledgement
#import "utils/custom-numbering.typ": custom-numbering
#import "utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "utils/custom-tablex.typ": *
#import "utils/indent.typ": indent
#import "@preview/i-figured:0.2.2": show-figure, show-equation
#import "utils/style.typ": 字体
#import "utils/style.typ": 字号
#import "@preview/algo:0.3.3": algo, i, d, comment, code
#import "@preview/tablex:0.0.8": tablex, gridx, hlinex, vlinex, colspanx, rowspanx

// 算法格式参数
#let algo_parameters = (
  line-numbers: true,
  strong-keywords: true,
  keywords: ("if", "else", "then", "while", "for", "repeat", "do", "until", ":", "end", "and", "or", "not", "in", "to", "down", "let", "return", "goto", "end if", "end for", "end while"), // see below
  comment-prefix: "// ",
  indent-size: 20pt,
  indent-guides: none,
  indent-guides-offset: 0pt,
  row-gutter: 10pt,
  column-gutter: 10pt,
  inset: 12pt,
  fill: rgb(100%, 100%, 100%),
  stroke: 1pt + rgb(50%, 50%, 50%),
  radius: 4pt,
  breakable: false,
  block-align: center,
  main-text-styles: (size: 12pt),
  comment-styles: (fill: rgb(0%, 0%, 0%)),
  line-number-styles: (font: "Times New Roman")
)

// 三线表规格
#let tophlinex() = hlinex(stroke: 1.5pt)
#let midhlinex() = hlinex(stroke: 0.75pt)
#let bottomhlinex() = hlinex(stroke: 1.5pt)
#let topvlinex() = vlinex(stroke: 1.5pt)
#let midvlinex() = vlinex(stroke: 0.75pt)
#let bottomvlinex() = vlinex(stroke: 1.5pt)

// 使用函数闭包特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `templates` 内部函数。
#let documentclass(
  type: "master",  // "bachelor" | "master" ，文档类型，默认为本科生 bachelor
  degree: "academic",  // "academic" | "professional"，学位类型，默认为学术型 academic
  nl-cover: false,  // TODO: 是否使用国家图书馆封面，默认关闭
  twoside: false,  // 双面模式，会加入空白页，便于打印
  anonymous: false,  // 盲审模式
  fonts: (:),  // 字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  info: (:),
) = {
  // 默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "湖南师范大学学位论文"),
    title-en: "The master thesis of HNU based on Typst",
    grade: "2021",
    student-id: "202129293792",
    author: "张三",
    author-en: "zhang san",
    department: "信息科学与工程学院",
    department-en: "XX Department",
    major: "计算机科学与技术",
    major-en: "XX Major",
    field: "机器学习",
    field-en: "XX Field",
    supervisor: ("李四", "教授"),
    supervisor-en: "Professor Li Si",
    supervisor-ii: (),
    supervisor-ii-en: "",
    submit-date: datetime.today(),
    // 以下为研究生项
    defend-date: datetime.today(),
    confer-date: datetime.today(),
    bottom-date: datetime.today(),
    thesis_type: $checkmark$ + " 科学学位 " + $square.stroked.medium$ + " 专业学位",
    thesis_number: "4631471641692346162",
    // chairman: "某某某 教授",
    reviewer: ("某某某 教授", "某某某 教授"),
    // clc: "O643.12",
    // udc: "544.4",
    secret-level: "公开",
    // supervisor-contact: "湖南师范大学 湖南省长沙市岳麓区橘子洲街道",
    email: "xyz@smail.hnu.edu.cn",
    school-code: "10542",
    degree: auto,
    degree-en: auto,
  ) + info

  (
    // 页面布局
    doc: (..args) => {
      doc(
        ..args,
        info: info + args.named().at("info", default: (:)),
      )
    },
    preface: (..args) => {
      preface(
        twoside: twoside,
        ..args,
      )
    },
    mainmatter: (..args) => {
      mainmatter(
        twoside: twoside,
        display-header: true,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },
    mainmatter-end: (..args) => {
      mainmatter-end(
        ..args,
      )
    },
    appendix: (..args) => {
      appendix(
        ..args,
      )
    },

    // 字体展示页
    fonts-display-page: (..args) => {
      fonts-display-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 封面页
    cover: (..args) => {
      master-cover(
        type: type,
        degree: degree,
        nl-cover: nl-cover,
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },

    // 声明页
    decl-page: (..args) => {
      master-decl-page(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },
    
    // 中文摘要页
    abstract: (..args) => {
      master-abstract(
        type: type,
        degree: degree,
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },

    // 英文摘要页
    abstract-en: (..args) => {
      master-abstract-en(
        type: type,
        degree: degree,
        anonymous: anonymous,
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
        info: info + args.named().at("info", default: (:)),
      )
    },

    // 目录页
    outline-page: (..args) => {
      bachelor-outline-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 符号表页
    notation: (..args) => {
      notation(
        twoside: twoside,
        ..args,
      )
    },

    // 致谢页
    acknowledgement: (..args) => {
      acknowledgement(
        anonymous: anonymous,
        twoside: twoside,
        ..args,
      )
    },
  )
}
