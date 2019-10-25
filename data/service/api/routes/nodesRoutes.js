'use strict';

module.exports = function(app) {
    var nodesList = require('../controllers/nodesController');

    app.route('/nodes')
        .get(nodesList.getAllNodes);

    app.route('/nodes/:nodeId')
        .get(nodesList.getNode);

    app.route('/nodes/:nodeId/ping')
        .post(nodesList.pingNode);

    app.route('/nodes/:nodeId/iperf')
        .post(nodesList.iperfNode);

    app.route('/nodes/:nodeId/xfer')
        .post(nodesList.xferNode);
};

