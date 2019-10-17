'use strict';

const { exec } = require('child_process');

exports.getMe = function(req, res) {
    const child = exec('/scripts/get-me.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

exports.getNics = function(req, res) {
    const child = exec('/scripts/get-nics.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

exports.getTincd = function(req, res) {
    const child = exec('/scripts/get-tincd.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

exports.getTincdLog = function(req, res) {
    const child = exec('/scripts/get-tincd-log.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

exports.getIperf = function(req, res) {
    const child = exec('/scripts/get-iperf.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

exports.startIperf = function(req, res) {
    const child = exec('/scripts/start-iperf.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
}

exports.getIperfLog = function(req, res) {
    const child = exec('/scripts/get-iperf-log.sh', (err, stdout, stderr) => {
        if (err) {
            var message = `${err}`;
            console.error(`exec error: ${message}`);
            return res.status(400).send({ message: `${message}` });
        }
        res.send(`${stdout}`);
    });
};

