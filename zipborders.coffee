fs = require('fs')
_ = require('underscore')
libxmljs = require("libxmljs")
geolib = require("geolib")
express = require("express")
app = express()
server = require("http").createServer(app)

app.use(express.logger())

loadSvg = (mapFilename) ->
  zips = {} # zip : record
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

    zips[zip] = {
      zip: zip
      center: center
      postname: attrs.postname
      xml: g.toString()
    }
  console.log("loaded "+Object.keys(zips).length+" zip boundaries")
  zips

zips = loadSvg('zipmap/allzips.svg')

app.get "/", (req, res) ->
  res.write("zipborders server")
  res.end()

app.get "/zipOutline/:zip", (req, res) ->
  requestedZips = req.params.zip.split(",")
  if requestedZips.length > 1000
    return res.send(500)

  res.write('<svg xmlns="http://www.w3.org/2000/svg">')
    
  requestedZips.forEach (z) ->
    res.write(zips[z].xml)

  res.write('</svg>')
  res.end()

app.get "/near", (req, res) ->
  zip = req.query.zip
  m = parseFloat(req.query.meters)
  console.log("finding", m, "m near", zip)
  requestedCenter = zips[zip]
  if not requestedCenter?
    return res.send(400, zip)
  requestedCenter = requestedCenter.center

  closeZips = []
  for z, row of zips
    d = geolib.getDistance(row.center, requestedCenter)
    if (d < m)
      closeZips.push(_.extend({distm: d}, row))
  
  res.json({"near": closeZips})

server.listen(3192)
console.log("serving on port 3192")

