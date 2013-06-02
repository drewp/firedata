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

csv = require('csv')
fs = require('fs')
zlib = require('zlib')
zipRows = {} # zip : row

gunzip = zlib.createGunzip()
inStream = fs.createReadStream("./data/challenge_20130429.csv.gz").pipe(gunzip)
csv().from.stream(inStream, {columns: true}).transform((row) ->
  zipRows[row.ZIP] = row
  zipRows[row.ZIP].Fires = parseInt(zipRows[row.ZIP].Fires)
)

app.get "/", (req, res) ->
  row = zipRows[req.query.zip]



  nearbyZips = restler.get(zipborders + "near",
                           {query: {
                              meters: 15 * 1609
                              zip: req.query.zip
                           }}).on('complete', (result) ->
      if (result instanceof Error)
        console.log(result)
        return res.send(500)

      tot = 0
      result.near.forEach (near) ->
        nearRow = zipRows[near.zip]
        if nearRow?
          tot += nearRow.Fires
  
      res.render("index.jade", {
        totalNearby: tot
        row: row
      })
        
  )
  
server.listen(3001)
console.log("serving on port 3001")
