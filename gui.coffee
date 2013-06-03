svg = d3.select("svg")

class Coords
  constructor: (svg) ->
    @radiusMeters = 15*1609 # set how many meters it is from center to right
    
    @aspect = 1.5
    @centerLon = -122.25
    @centerLat = 37.53
        
    jq = $(svg[0][0])
    normalizedCoords = svg.append("svg:g")
    [hw, hh] = [jq.width() / 2, jq.height() / 2]
    normalizedCoords.attr("transform", "translate("+hw+" "+hh+") scale("+hw+" "+hw+")")
    @geoCoords = normalizedCoords.append("svg:g")
    @updateTransform()
    
  updateTransform: () =>
    # (this is exact at 45deg latitude)
    metersPerLonDeg = 78846
    scl = metersPerLonDeg / @radiusMeters
    @geoCoords.attr("transform", "scale("+(scl)+" "+(-scl * @aspect)+") "+
                                 "translate("+(-@centerLon)+" "+
                                              (-@centerLat)+")")
              
    
coords = new Coords(svg)
coords.radiusMeters = diagramData.radius

zipBoundaries = coords.geoCoords.append("svg:g")
zipBoundaries.attr("class", "zipBoundaries")

addSvgGroupFromXml = (d3Node, xmlString) ->
  # thanks, http://stackoverflow.com/a/9724151/112864
  withNamespace = '<svg xmlns="http://www.w3.org/2000/svg">' + xmlString + '</svg>'
  parser = new window.DOMParser()
  doc = parser.parseFromString(withNamespace, 'image/svg+xml')
  newGroup = doc.documentElement.firstChild
  d3Node[0][0].appendChild(document.importNode(newGroup, true))


if diagramData.nearZips?
  diagramData.nearZips.forEach (zip) ->
    d3.text("zipborders/zipOutline/" + zip, (xmlString) ->
      grp = addSvgGroupFromXml(zipBoundaries, xmlString)
      if zip == diagramData.queryZip
        d3.select(grp).classed("queried", true);
        window.grp = grp
        coords.centerLon = parseFloat(grp.getAttribute("lon"))
        coords.centerLat = parseFloat(grp.getAttribute("lat"))
        coords.updateTransform()
    )
    