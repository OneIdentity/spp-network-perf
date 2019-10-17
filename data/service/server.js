var express = require('express'),
    app = express(),
    port = process.env.PORT || 8080;

var meRoutes = require('./api/routes/meRoutes');
var nodesRoutes = require('./api/routes/nodesRoutes');
var perfRoutes = require('./api/routes/perfRoutes');
meRoutes(app);
nodesRoutes(app);
perfRoutes(app);

app.use(function(req, res) {
    res.status(404).send({url: req.originalUrl + ' not found'})
});

app.listen(port);

console.log('Web API server started on: ' + port);
console.log('Endpoints:');
console.log('  GET me');
console.log('  GET me/nics');
console.log('  GET me/tincd');
console.log('  GET me/tincd/log');
console.log('  GET me/iperf');
console.log('  GET me/iperf/log');
console.log('  GET nodes');
console.log('  GET nodes/{id}');
console.log('  POST nodes/{id}/ping');
console.log('  POST perf/{id}');

