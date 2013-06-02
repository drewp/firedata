express = require("express")
build = require("consolidate-build")
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
)

app.get "/", (req, res) ->
  row = zipRows[req.query.zip]
  res.render("index.jade", {
    row: row
  })

server.listen(3001)
console.log("serving on port 3001")
