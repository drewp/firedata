fs = require('fs')
_ = require('underscore')
libxmljs = require("libxmljs")
geolib = require("geolib")
express = require("express")
app = express()
server = require("http").createServer(app)

app.use(express.logger())

loadSvg = (mapFilename) ->
  zips = []
  console.log("reading " + mapFilename)
  doc = libxmljs.parseXmlString(fs.readFileSync(mapFilename))

  doc.get("//g[@id='zips']").childNodes().forEach (g) ->
    if g.name() == "text"
      return
      
    attrs = {}
    for a in g.attrs()
      attrs[a.name()] = a.value()

    zip = attrs.id
    center = {latitude: parseFloat(attrs.lat), longitude: parseFloat(attrs.lon)}
    console.log("maps for", zip, g.name())

    zips.push({
      zip: zip
      center: center
      postname: attrs.postname
      xml: g.toString()
    })
  console.log("loaded "+zips.length+" zip boundaries")
  zips

zips = loadSvg('zipmap/allzips.svg')

app.get "/", (req, res) ->
  res.write("zipborders server")
  res.end()

app.get "/zipOutline/:zip", (req, res) ->
  zip = _.find(zips, (z) -> z.zip == req.params.zip)
  res.write(zip.xml)
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
