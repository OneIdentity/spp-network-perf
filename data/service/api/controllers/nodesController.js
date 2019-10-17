'use strict';

const { runScript } = require('./controllerUtils');

exports.getAllNodes = function(req, res) {
    runScript('/scripts/get-all-nodes.sh', req, res);
};

exports.getNode = function(req, res) {
    runScript('/scripts/get-node.sh ' + req.params.nodeId, req, res);
};

exports.pingNode = function(req, res) {
    runScript('/scripts/ping-node.sh ' + req.params.nodeId, req, res);
};

exports.iperfNode = function(req, res) {
    runScript('/scripts/iperf-node.sh ' + req.params.nodeId, req, res);
}

