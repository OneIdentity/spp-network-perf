'use strict';

const { exec } = require('child_process');

exports.getAllNodes = function(req, res) {
    const child = exec('/scripts/get-all-nodes.sh', (err, stdout, stderr) => {
        if (err) {
            console.error(`exec error: ${err}`);
            return;
        }
        res.send(`${stdout}`);
    });
};

exports.getNode = function(req, res) {
    const child = exec('/scripts/get-node.sh ' + req.params.nodeId, (err, stdout, stderr) => {
        if (err) {
            console.error(`exec error: ${err}`);
            return;
        }
        res.send(`${stdout}`);
    });
};

