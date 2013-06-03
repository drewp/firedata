svg = d3.select("svg")
trans = (tx, ty) -> " translate("+tx+" "+ty+")"
scale = (sx, sy) -> " scale("+sx+" "+sy+")"

class Coords
  constructor: (svg) ->
    @radiusMeters = 15*1609 # set how many meters it is from center to right
    
    @aspect = 1.5
    @centerLon = 0
    @centerLat = 0
        
    jq = $(svg[0][0])
    normalizedCoords = svg.append("svg:g")
    [hw, hh] = [jq.width() / 2, jq.height() / 2]
    normalizedCoords.attr("transform", trans(hw, hh) + scale(hw, hw))
    @geoCoords = normalizedCoords.append("svg:g")
    @updateTransform()

    
  updateTransform: () =>
    # (this is exact at 45deg latitude)
    metersPerLonDeg = 78846
    @scl = metersPerLonDeg / @radiusMeters
    @geoCoords.attr("transform", scale(@scl, -@scl * @aspect) +
                                 trans(-@centerLon, -@centerLat))
  undoGeoFlipTransform: () =>
    return scale(1 / @scl, 1 / (-@scl * @aspect))
              
    
coords = new Coords(svg)
coords.radiusMeters = diagramData.radius * .8

zipBoundaries = coords.geoCoords.append("svg:g")
zipBoundaries.attr("class", "zipBoundaries")

labels = coords.geoCoords.append("svg:g").attr("class", "labels")

addSvgGroupFromXml = (d3Node, xmlString) ->
  # thanks, http://stackoverflow.com/a/9724151/112864
  parser = new window.DOMParser()
  doc = parser.parseFromString(xmlString, 'image/svg+xml')
  newGroup = doc.documentElement
  all = document.importNode(newGroup, true)
  groups = []
  while all.firstChild
    groups.push(all.firstChild)
    d3Node[0][0].appendChild(all.firstChild)
  groups

if diagramData.nearZips?
  commas = diagramData.nearZips.join(",")

  d3.text("zipborders/zipOutline/" + commas, (xmlString) ->
    groups = addSvgGroupFromXml(zipBoundaries, xmlString)

    for group in groups
      groupZip = group.getAttribute("id")

      if groupZip == diagramData.queryZip
        d3.select(group).classed("queried", true);
        coords.centerLon = parseFloat(group.getAttribute("lon"))
        coords.centerLat = parseFloat(group.getAttribute("lat"))
        coords.updateTransform()
        
    for group in groups
      groupZip = group.getAttribute("id")

      g = labels.append("svg:g")
      g.attr("transform", trans(parseFloat(group.getAttribute("lon")),
                                parseFloat(group.getAttribute("lat"))))

      g.append("svg:text")
      .attr("transform", coords.undoGeoFlipTransform())
      .text(groupZip)

      if false # not useful yet
        $(group).click(() ->
          console.log($(this).attr("id"))
          coords.centerLon = parseFloat($(this).attr("lon"))
          coords.centerLat = parseFloat($(this).attr("lat"))
          coords.updateTransform()
          
        )
  )
