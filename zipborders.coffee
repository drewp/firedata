fs = require('fs')
_ = require('underscore')
xml = require('xml-object-stream')
geolib = require("geolib")
express = require("express")
app = express()
server = require("http").createServer(app)

app.use(express.logger())

loadSvg = () ->
  readStream = fs.createReadStream('zipmap/06-fix.svg')
  parser = xml.parse(readStream)

  zips = []
  parser.each 'g', (g) ->
    zip = g.$.id
    center = {latitude: parseFloat(g.$.lat), longitude: parseFloat(g.$.lon)}
    zips.push({zip: zip, center: center, postname: g.$.postname})
  zips

zips = loadSvg()

app.get "/", (req, res) ->
  res.write("zipborders server")
  res.end()

app.get "/zipOutline/:zip", (req, res) ->
  res.write("<g></g>")
  res.end()

app.get "/near", (req, res) ->
  console.log(req.query)
  zip = req.query.zip
  m = parseFloat(req.query.meters)
  console.log("finding ", m, " m near ", zip)
  requestedCenter = _.find(zips, (z) -> z.zip == zip)
  if not requestedCenter?
    return res.send(400, zip)
  requestedCenter = requestedCenter.center

  closeZips = []
  zips.forEach (z) ->
    d = geolib.getDistance(z.center, requestedCenter)
    if (d < m)
      closeZips.push(_.extend({distm: d}, z))
      
  
  res.json({"near": closeZips})


server.listen(3002)
console.log("serving on port 3002")
