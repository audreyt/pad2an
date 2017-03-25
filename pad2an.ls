require! <[ cheerio xml ]>

export function pad2an (html)
  $ = cheerio.load(html)

  root-section = debate-section = []
  speaker = ''
  speech = []
  speakers = {}
  timestamp = ''
  recording-start = $("p:contains('\u231B')").text! - /[\u231B]/ - /\s*$/ - /^\s*/

  $('p, ul, h1, h2').each ->
    $(@).remove('.comment')
    return if $(@).has-class \comment
    {p, ul, h1, h2}[@name].call $(@)

  if speech.length and speaker
    speakers[speaker] = true
    debate-section.push({ speech: [{_attr: { by: "\##speaker" }}].concat(speech)} )

  function h1
    t = @text! - /\s*$/
    debate-section.push heading: t

  function h2
    t = @text! - /\s*$/
    if speech.length and speaker
      debate-section.push({ speech: [{_attr: { by: "\##speaker" }}].concat(speech)} )
      speech := []
      speaker := null
    debate-section := []
    debate-section.push heading: t
    root-section.push { debate-section }

  function p
    t = @text! - /\s*$/
    if speech.length and speaker
      speakers[speaker] = true
      attributes = [{ by: "\##speaker" }]
      if !!timestamp and !!recording-start
        speaker-starttime = new Date(new Date(recording-start).getTime! + (timestamp / ':')[0]*60000).toISOString!
        attributes ++= [{ startTime: speaker-starttime }]
      attributes = Object.assign ...attributes
      debate-section.push({ speech: [{_attr: attributes}].concat(speech)} )
      speech := []
      timestamp := ''
    if t is /^[(（].*[）)]$/
      debate-section.push({ narrative: [{ p: [{ i: t }] }] })
      return
    else if t is /[\u00A0\u3000]{2}/
      speech ++= [ { p: t - /[\u00A0\u3000]/g - /\s*$/ - /^\s*/ } ]
    else if @find 'a[href]' .length
      anchors = []
      debate-section.push({ narrative: [{ p: anchors }] })
      anchors.push $(@).clone!remove('a')text! - /https?\:\/\/\S+/
      <- @find 'a[href]' .each
      anchors.push { a: [{ _attr: { href: $(@).attr('href') } }, $(@).text! or $(@).attr('href') ] }
    else if t is /[:：]/
      [first, ...rest] = t / /[:：]/
      timestamp := rest * ':'
      speaker := first - /^\s+/ - /\s+$/

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
    { debateBody: [{ debate-section: root-section }] }
  ]}]}
  return xml(an, '  ')
