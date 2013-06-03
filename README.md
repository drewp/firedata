This is a SVG-map-drawing experiment for
http://hackforchange.org/challenge/fire-data-visualization


Live deployment:

http://bigasterisk.com/firedata/


To run it yourself:

See zipmap/readme for a map file to download.

npm install

Run these two services:

node_modules/node-dev/bin/node-dev zipborders.coffee
node_modules/node-dev/bin/node-dev firedata.coffee

Serve them such that your/path1/ (any path) proxies to the server at
port 3191 and your/path1/zipborders/ proxies to the server at port
3192.