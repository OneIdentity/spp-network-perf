'use strict';

const { runScript } = require('./controllerUtils');

exports.getMe = function(req, res) {
    runScript('/scripts/get-me.sh', req, res);
};

exports.getNics = function(req, res) {
    runScript('/scripts/get-nics.sh', req, res);
};

exports.getTincd = function(req, res) {
    runScript('/scripts/get-tincd.sh', req, res);
};

exports.getTincdLog = function(req, res) {
    runScript('/scripts/get-tincd-log.sh', req, res);
};

exports.signalTincdStats = function(req, res) {
    runScript('/scripts/signal-tincd-stats.sh', req, res);
};

exports.getIperf = function(req, res) {
    runScript('/scripts/get-iperf.sh', req, res);
};

exports.startIperf = function(req, res) {
    runScript('/scripts/start-iperf.sh', req, res);
}

exports.getIperfLog = function(req, res) {
    runScript('/scripts/get-iperf-log.sh', req, res);
};

