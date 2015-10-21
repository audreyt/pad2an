require! <[ cheerio xml ]>

export function pad2an (html)
  $ = cheerio.load(html)

  debate-section = []
  speaker = ''
  speech = []
  speakers = {}

  $('p, ul, h1').each ->
    $(@).remove('.comment')
    return if $(@).has-class \comment
    {p, ul, h1}[@name].call $(@)

  if speech.length and speaker
    speakers[speaker] = true
    debate-section.push({ speech: [{_attr: { by: "\##speaker" }}].concat(speech)} )

  function h1
    t = @text! - /\s*$/
    debate-section.push heading: t

  function p
    t = @text! - /\s*$/
    if speech.length and speaker
      speakers[speaker] = true
      debate-section.push({ speech: [{_attr: { by: "\##speaker" }}].concat(speech)} )
      speech := []
    if t is /^[(（].*[）)]$/
      debate-section.push({ narrative: [{ p: [{ i: t }] }] })
      return
    else if t is /[:：]$/
      speaker := t.slice(0, -1) - /^\s+/ - /\s+$/
    else if @find 'a[href]' .length
      anchors = []
      debate-section.push({ narrative: [{ p: anchors }] })
      anchors.push $(@).clone!remove('a')text! - /https?\:\/\/\S+/
      <- @find 'a[href]' .each
      anchors.push { a: [{ _attr: { href: $(@).attr('href') } }, $(@).text! or $(@).attr('href') ] }

  function ul
    <- @find 'li:not(.comment)' .each
    t = $(@)text! - /\s*$/
    speech ++= [ { p: t } ]

  references = []
  for it in Object.keys(speakers).sort!
    references.push { TLCPerson: [{ _attr: {
      href: "/ontology/person/::/#it"
      id: it
      showAs: it
    }}] }

  an = { akomaNtoso: [{ debate: [
    {meta: [{references}]},
    { debateBody: [{ debate-section }] }
  ]}]}
  return xml(an, '  ')
