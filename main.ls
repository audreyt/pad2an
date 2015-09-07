require! <[ fs cheerio xml ]>
html = fs.read-file-sync \in.html \utf8
$ = cheerio.load(html)

debate-section = []
speaker = ''
speech = []

$('p, ul, h1').each ->
  return if $(@).has-class \comment
  {p, ul, h1}[@name].call $(@)

function h1
  debate-section.push @text!

function p
  t = @text! - /\s*$/
  if speech.length and speaker
    debate-section.push({ speech: [{_attr: { by: "\##speaker" }}].concat(speech)} )
    speech := []
  if t is /^[(（].*[）)]$/
    debate-section.push({ narrative: [{ p: t }] })
    return
  else if t is /[:：]$/
    speaker := t.slice(0, -1)

function ul
  <- @find 'li:not(.comment)' .each
  t = $(@)text! - /\s*$/
  speech ++= [ { p: t } ]

an = { akomaNtoso: [{ debate: [
  # {meta: [{references: References}]}, // 替TLCPerson 保留
  # {preface: Preface}, // 替文件名稱保留
  { debateBody: [{ debate-section }] }
]}]}
console.log(xml(an, '  '))
