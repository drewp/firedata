csv = require('csv')
fs = require('fs')
zlib = require('zlib')
express = require("express")
build = require("consolidate-build")
restler = require("restler")
zipborders = 'http://localhost:3192/'

app = express()
server = require("http").createServer(app)

app.set('views', __dirname)

app.engine("jade", build.jade)
app.engine("coffee", build.coffee)

app.use("/static", express.static(__dirname + '/static'));
app.use(express.logger())
app.use(express.bodyParser())

padZip = (s) ->
  return null if not s?
  ('00000' + s).slice(-5)

loadChallengeData = (filename, cb) ->
  zipRows = {} # zip : row

  gunzip = zlib.createGunzip()
  inStream = fs.createReadStream(filename).pipe(gunzip)
  csv().from.stream(inStream, {columns: true}).transform((row) ->
    row.ZIP = padZip(row.ZIP)
    zipRows[row.ZIP] = row
  ).on('end', (count) ->
    console.log("read "+count+" rows")
    cb(null, zipRows)
  )

loadChallengeData "./data/challenge_20130429.csv.gz", (err, zipRows) -> 

  app.get "/", (req, res) ->
    radius = 25 * 1609

    queryZip = padZip(req.query.zip)

    finish = (tot, nearRecords, row) ->
      # this would run again at odd times without the bug fix in
      # https://github.com/danwrong/restler/pull/113
      res.render("index.jade", {
        totalNearby: tot
        diagramData: {
          nearZips: if nearRecords then (n.zip for n in nearRecords) else null
          queryZip: queryZip
          radius: radius
        }
        row: row
      })

    row = zipRows[queryZip]

    restler.get(zipborders + "near",
                {query: {
                   meters: radius
                   zip: queryZip
                }}).on 'complete', (result, response) ->
        if (result instanceof Error or not result?.near?)
          return finish(null, null, row)
          
        tot = 0
        result.near.forEach (near) ->
          nearRow = zipRows[near.zip]
          if nearRow?
            tot += parseInt(nearRow.Fires)
        finish(tot, result.near, row)
    

  app.get "/gui.js", (req, res) ->
      res.contentType("text/javascript")
      res.render("gui.coffee")

  server.listen(3191)
  console.log("serving on port 3191")
    