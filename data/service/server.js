var express = require('express'),
    app = express(),
    port = process.env.PORT || 8080;

var nodesRoutes = require('./api/routes/nodesRoutes');
var perfRoutes = require('./api/routes/perfRoutes');
nodesRoutes(app);
perfRoutes(app);

app.use(function(req, res) {
    res.status(404).send({url: req.originalUrl + ' not found'})
});

app.listen(port);

console.log('Web API server started on: ' + port);
console.log('Endpoints:');
console.log('  GET nodes');
console.log('  GET nodes/{id}');
console.log('  POST perf/{id}');

