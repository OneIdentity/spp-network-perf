'use strict';

const { exec } = require('child_process');

exports.getAllNodes = function(req, res) {
    //const child = exec('cmd', ['arg1', 'arg2']);
    //console.log('error', child.error);
    //console.log('stdout ', child.stdout);
    //console.log('stderr ', child.stderr);
    res.send('node1,node2,node3');
};

exports.getNode = function(req, res) {
    res.send('node' + req.params.nodeId);
};

