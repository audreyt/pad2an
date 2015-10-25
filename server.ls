require! http
http.createServer(({url}, res) ->
  #console.log url
  url -= // ^ /? https? : / / //
  url.=replace // ^
    ( (?: \w+\. )? hackpad\.com )
    / (?: [^/]*-- )? ( [^/]+ )
  $ //, "$1/ep/pad/static/$2"
  console.log "=> #url"
  unless url is // ^ (?: \w+\. )?  hackpad.com /ep/pad/static/ //
    res.writeHead 400, 'Content-Type': \text/plain
    res.end "URL must match hackpad.com/ep/pad/static/"
    return
  request = require \superagent-bluebird-promise
  { pad2an } = require './pad2an.ls'
  request.get("https://#url").then(({res: {text}}) ->
    res.writeHead 200, 'Content-Type': 'text/xml; charset=utf-8'
    res.end pad2an text
  , (err) ->
    res.writeHead 400, 'Content-Type': \text/plain
    res.end "Error: #err"
  )
).listen 8080 -> console.log "http://127.0.0.1:8080/"
