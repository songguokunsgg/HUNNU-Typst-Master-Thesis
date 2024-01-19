#import "@preview/t4t:0.3.2": is
#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/justify-text.typ": justify-text
#import "../utils/style.typ": 字号, 字体

// 硕士研究生封面
#let master-cover(
  // documentclass 传入的参数
  type: "master",
  degree: "academic",
  nl-cover: false,
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  min-title-lines: 2,
  min-reviewer-lines: 5,
  info-inset: (x: 0pt, bottom: 0.5pt),
  info-key-width: 110pt,
  info-column-gutter: 18pt,
  info-row-gutter: 12pt,
  meta-block-inset: (left: -15pt),
  meta-info-inset: (x: 0pt, bottom: 2pt),
  meta-info-key-width: 35pt,
  meta-info-column-gutter: 10pt,
  meta-info-row-gutter: 1pt,
  defence-info-inset: (x: 0pt, bottom: 0pt),
  defence-info-key-width: 110pt,
  defence-info-column-gutter: 2pt,
  defence-info-row-gutter: 12pt,
  anonymous-info-keys: ("student-id", "author", "author-en", "supervisor", "supervisor-en", "supervisor-ii", "supervisor-ii-en", "chairman", "reviewer"),
  datetime-display: datetime-display,
  datetime-en-display: datetime-en-display,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "湖南师范大学学位论文"),
    grade: "2021",
    student-id: "202120293792",
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
    submit-date: datetime.today(),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if (is.str(info.title)) {
    info.title = info.title.split("\n")
  }
  if (is.str(info.title-en)) {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 根据 min-title-lines 和 min-reviewer-lines 填充标题和评阅人
  info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
  info.reviewer = info.reviewer + range(min-reviewer-lines - info.reviewer.len()).map((it) => "　")
  // 2.3 处理日期
  assert(is.type(datetime, info.submit-date), message: "submit-date must be datetime.")
  if (is.type(datetime, info.defend-date)) {
    info.defend-date = datetime-display(info.defend-date)
  }
  if (is.type(datetime, info.confer-date)) {
    info.confer-date = datetime-display(info.confer-date)
  }
  if (is.type(datetime, info.bottom-date)) {
    info.bottom-date = datetime-display(info.bottom-date)
  }
  // 2.4 处理 degree
  if (info.degree == auto) {
    info.degree = "工程硕士"
  }

  // 3.  内置辅助函数
  let info-key(body, info-inset: info-inset, is-meta: false) = {
    set text(
      font: if is-meta { fonts.宋体 } else { fonts.楷体 },
      size: if is-meta { 字号.小五 } else { 字号.三号 },
      weight: if is-meta { "regular" } else { "bold" },
    )
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      justify-text(with-tail: is-meta, body)
    )
  }

  let info-value(key, body, info-inset: info-inset, is-meta: false, no-stroke: false) = {
    set align(center)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: if no-stroke { none } else { (bottom: stoke-width + black) },
      text(
        font: if is-meta { fonts.宋体 } else { fonts.楷体 },
        size: if is-meta { 字号.小五 } else { 字号.三号 },
        bottom-edge: "descender",
        if (anonymous and (key in anonymous-info-keys)) {
          if is-meta { "█████" } else { "██████████" }
        } else {
          body
        },
      ),
    )
  }

  let anonymous-text(key, body) = {
    if (anonymous and (key in anonymous-info-keys)) {
      "██████████"
    } else {
      body
    }
  }

  let meta-info-key = info-key.with(info-inset: meta-info-inset, is-meta: true)
  let meta-info-value = info-value.with(info-inset: meta-info-inset, is-meta: true)
  let defence-info-key = info-key.with(info-inset: defence-info-inset)
  let defence-info-value = info-value.with(info-inset: defence-info-inset)
  

  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  // 居中对齐
  set align(center)

  // 匿名化处理去掉封面标识
  if (anonymous) {
    v(50pt)
  } else {
    pad(image("../assets/vi/hunnu_log_red.svg", width: 14.5cm))
    v(45pt)
  }

  // 将中文之间的空格间隙从 0.25 em 调整到 0.5 em
  // 42pt 就是初号字
  text(size: 42pt, font: fonts.黑体, spacing: 200%, weight: "bold",
    "硕士学位论文",
  )
  
  if (anonymous) {
    v(5cm)
  } else {
    v(1.5cm)
  }

  text(size: 22pt, font: fonts.黑体, spacing: 200%, weight: "bold")[
    #for content in info.title [
      #content

    ]
  ]

  v(1.5cm)

  block(width: 330pt, grid(
    columns: (info-key-width, 1fr),
    column-gutter: info-column-gutter,
    row-gutter: info-row-gutter,
    info-key("学科专业"),
    info-value("major", info.major),
    info-key("学位类型"),
    info-value("thesis_type", info.thesis_type),
    info-key("研究生姓名"),
    info-value("author", info.author),
    info-key("导师姓名、职称"),
    info-value("supervisor", info.supervisor.intersperse(" ").sum()),
    ..(if info.supervisor-ii != () {(
      info-key("　"),
      info-value("supervisor-ii", info.supervisor-ii.intersperse(" ").sum()),
    )} else { () }),
    info-key("论文编号"),
    info-value("thesis_number", info.thesis_number)
  ))

  v(1.5cm)

  text(font: fonts.仿宋, size: 字号.四号)[
    湖南师范大学学位评定委员会办公室

    #datetime-display(info.submit-date)
  ]
}