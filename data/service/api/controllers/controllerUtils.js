'use strict';

const { exec } = require('child_process');

exports.runScript = function(command, req, res) {
    const child = exec(command, (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

