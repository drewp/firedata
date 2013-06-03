svg = d3.select("svg")

worldTransform = svg.append("svg:g")
worldTransform.attr("transform", "scale(600 600) translate(123 -37.3)")



addSvgGroupFromXml = (svgNode, xmlString) ->
  # thanks, http://stackoverflow.com/a/9724151/112864
  withNamespace = '<svg xmlns="http://www.w3.org/2000/svg">' + xmlString + '</svg>'
  parser = new window.DOMParser()
  doc = parser.parseFromString(withNamespace, 'image/svg+xml')
  newGroup = doc.documentElement.firstChild
  svgNode.appendChild(document.importNode(newGroup, true))


d3.text("zipborders/zipOutline/94002", (xmlString) ->
  addSvgGroupFromXml(worldTransform[0][0], xmlString)
)

