'use strict';

module.exports = function(app) {
  var nodesList = require('../controllers/nodesController');

  app.route('/nodes')
    .get(nodesList.getAllNodes);

  app.route('/nodes/:nodeId')
    .get(nodesList.getNode);
};

