csv = require('csv')
fs = require('fs')
zlib = require('zlib')
express = require("express")
build = require("consolidate-build")
restler = require("restler")
zipborders = 'http://localhost:3002/'

app = express()
server = require("http").createServer(app)

app.set('views', __dirname)

app.engine("jade", build.jade)
app.engine("coffee", build.coffee)

app.use("/static", express.static(__dirname + '/static'));
app.use(express.logger())
app.use(express.bodyParser())


loadChallengeData = () ->
  zipRows = {} # zip : row

  gunzip = zlib.createGunzip()
  inStream = fs.createReadStream("./data/challenge_20130429.csv.gz").pipe(gunzip)
  csv().from.stream(inStream, {columns: true}).transform((row) ->
    zipRows[row.ZIP] = row
    zipRows[row.ZIP].Fires = parseInt(zipRows[row.ZIP].Fires)
  )
  zipRows

zipRows = loadChallengeData()

app.get "/", (req, res) ->
  row = zipRows[req.query.zip]
  console.log("req", req._startTime)
  nearbyZips = restler.get(zipborders + "near",
                           {query: {
                              meters: 15 * 1609
                              zip: req.query.zip
                           }}).on('complete', (result) ->
      if (result instanceof Error)
        console.log("err", req._startTime)
        return res.send(500)

      if not result.near?
        result.near = []
        
      tot = 0
      result.near.forEach (near) ->
        nearRow = zipRows[near.zip]
        if nearRow?
          tot += nearRow.Fires

      console.log("success", req._startTime)
      # this would run again at odd times without the bug fix in
      # https://github.com/danwrong/restler/pull/113
      res.render("index.jade", {
        totalNearby: tot
        row: row
      })
  )

app.get "/gui.js", (req, res) ->
    res.contentType("text/javascript")
    res.render("gui.coffee")

server.listen(3001)
console.log("serving on port 3001")
