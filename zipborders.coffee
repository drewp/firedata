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
  res.write('<g id="94002" postname="Belmont" cntyname="San Mateo" cafintrst="One Coastal Watershed" pop2000="25548" hostcount="1077" lat="37.534500" lon="-122.254600">

<polygon points=" -122.276650,37.534291 -122.273300,37.534500 -122.273200,37.531100 -122.270797,37.530464 -122.269200,37.529300 -122.254600,37.516600 -122.259300,37.518600 -122.257400,37.515100 -122.258900,37.514300 -122.261600,37.516300 -122.264800,37.513700 -122.267400,37.515500 -122.272700,37.511100 -122.277300,37.514300 -122.278200,37.512100 -122.284100,37.510400 -122.286100,37.511200 -122.288800,37.503000 -122.285900,37.501700 -122.287216,37.501060 -122.286500,37.499300 -122.289400,37.500900 -122.288925,37.498978 -122.291700,37.499900 -122.291100,37.497900 -122.293100,37.497100 -122.300300,37.500900 -122.302400,37.499000 -122.294700,37.493400 -122.297100,37.494800 -122.300300,37.493600 -122.338400,37.505400 -122.328800,37.512900 -122.324000,37.517400 -122.324400,37.519500 -122.322800,37.520800 -122.313700,37.519300 -122.310800,37.524300 -122.306200,37.521100 -122.284700,37.531000 -122.277900,37.529400 -122.274400,37.531400 -122.276650,37.534291"/>
</g>')
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


server.listen(3192)
console.log("serving on port 3192")
