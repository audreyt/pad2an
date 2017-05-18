require! http
index-html = require('fs').readFileSync('index.html' \utf8)
port = process.env['PORT'] ? 8080
http.createServer(({url}, res) ->
  #console.log url
  if url is '/'
    res.writeHead 200, 'Content-Type': 'text/html; charset=utf-8'
    res.end index-html
    return
  url -= // ^ /? https? : / / //
  url.=replace // ^
    ( (?: \w+\. )? hackpad (\.com | \.tw) | pad\.g0v\.link )
    / (?: [^/]*- )? ( [^/]+ )
  $ //, "$1/ep/pad/static/$2"
  console.log "=> #url"
  unless url is // ^ ( (?: \w+\. )?  hackpad (\.com | \.tw) | pad\.g0v\.link ) /ep/pad/static/ //
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
).listen port, -> console.log "http://127.0.0.1:#port/"
