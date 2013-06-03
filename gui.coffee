svg = d3.select("svg")

worldTransform = svg.append("svg:g")
worldTransform.attr("transform", "translate(124 0)")

worldTransform.append("svg:circle").attr("r","3").attr("cx","-122.276650").attr("cy","37.534291")

ret = '<g id="94002" postname="Belmont" cntyname="San Mateo" cafintrst="One Coastal Watershed" pop2000="25548" hostcount="1077" lat="37.534500" lon="-122.254600">

<circle r="4" cx="-122.276650" cy="37.534291"/>
<circle r="4" cx="-122.273300" cy="37.534500"/>
<circle r="4" cx="-122.273200" cy="37.531100"/>
<circle r="4" cx="-122.270797" cy="37.530464"/>
<circle r="4" cx="-122.269200" cy="37.529300"/>
<circle r="4" cx="-122.254600" cy="37.516600"/>
<circle r="4" cx="-122.259300" cy="37.518600"/>
<circle r="4" cx="-122.257400" cy="37.515100"/>
<circle r="4" cx="-122.258900" cy="37.514300"/>
<circle r="4" cx="-122.261600" cy="37.516300"/>
<circle r="4" cx="-122.264800" cy="37.513700"/>
<circle r="4" cx="-122.267400" cy="37.515500"/>
<circle r="4" cx="-122.272700" cy="37.511100"/>
<circle r="4" cx="-122.277300" cy="37.514300"/>
<circle r="4" cx="-122.278200" cy="37.512100"/>
<circle r="4" cx="-122.284100" cy="37.510400"/>
<circle r="4" cx="-122.286100" cy="37.511200"/>
<circle r="4" cx="-122.288800" cy="37.503000"/>
<circle r="4" cx="-122.285900" cy="37.501700"/>
<circle r="4" cx="-122.287216" cy="37.501060"/>
<circle r="4" cx="-122.286500" cy="37.499300"/>
<circle r="4" cx="-122.289400" cy="37.500900"/>
<circle r="4" cx="-122.288925" cy="37.498978"/>
<circle r="4" cx="-122.291700" cy="37.499900"/>
<circle r="4" cx="-122.291100" cy="37.497900"/>
<circle r="4" cx="-122.293100" cy="37.497100"/>
<circle r="4" cx="-122.300300" cy="37.500900"/>
<circle r="4" cx="-122.302400" cy="37.499000"/>
<circle r="4" cx="-122.294700" cy="37.493400"/>
<circle r="4" cx="-122.297100" cy="37.494800"/>
<circle r="4" cx="-122.300300" cy="37.493600"/>
<circle r="4" cx="-122.338400" cy="37.505400"/>
<circle r="4" cx="-122.328800" cy="37.512900"/>
<circle r="4" cx="-122.324000" cy="37.517400"/>
<circle r="4" cx="-122.324400" cy="37.519500"/>
<circle r="4" cx="-122.322800" cy="37.520800"/>
<circle r="4" cx="-122.313700" cy="37.519300"/>
<circle r="4" cx="-122.310800" cy="37.524300"/>
<circle r="4" cx="-122.306200" cy="37.521100"/>
<circle r="4" cx="-122.284700" cy="37.531000"/>
<circle r="4" cx="-122.277900" cy="37.529400"/>
<circle r="4" cx="-122.274400" cy="37.531400"/>
<circle r="4" cx="-122.276650" cy="37.534291"/>
    
<polygon points=" -122.276650,37.534291 -122.273300,37.534500 -122.273200,37.531100 -122.270797,37.530464 -122.269200,37.529300 -122.254600,37.516600 -122.259300,37.518600 -122.257400,37.515100 -122.258900,37.514300 -122.261600,37.516300 -122.264800,37.513700 -122.267400,37.515500 -122.272700,37.511100 -122.277300,37.514300 -122.278200,37.512100 -122.284100,37.510400 -122.286100,37.511200 -122.288800,37.503000 -122.285900,37.501700 -122.287216,37.501060 -122.286500,37.499300 -122.289400,37.500900 -122.288925,37.498978 -122.291700,37.499900 -122.291100,37.497900 -122.293100,37.497100 -122.300300,37.500900 -122.302400,37.499000 -122.294700,37.493400 -122.297100,37.494800 -122.300300,37.493600 -122.338400,37.505400 -122.328800,37.512900 -122.324000,37.517400 -122.324400,37.519500 -122.322800,37.520800 -122.313700,37.519300 -122.310800,37.524300 -122.306200,37.521100 -122.284700,37.531000 -122.277900,37.529400 -122.274400,37.531400 -122.276650,37.534291"/>
</g>'

recv = document.createElementNS("http://www.w3.org/2000/svg", "svg");
recv.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:xlink", "http://www.w3.org/1999/xlink");
window.recv = recv
window.ret = ret
recv.innerHTML = ret
console.log(recv)

if false
    @waitingSvgDataUrl = "data:image/svg+xml;base64,"+btoa(data)
    elem = document.getElementById(id)
    # at least sometimes, this leaves xlink:href alone and sets href,
    # and href wins. setAttributeNS worked worse.
    elem.setAttribute('xlink:href', value) if elem?

if false
    parser = new window.DOMParser()
    newGroup = parser.parseFromString(ret, 'image/svg+xml').firstChild
    worldTransform[0][0].appendChild(newGroup)

#d3.xml("zipOutline", "image/svg+xml", (xml) ->
#  console.log(xml)


