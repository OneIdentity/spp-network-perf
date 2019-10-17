'use strict';

module.exports = function(app) {
    var meHandler = require('../controllers/meController');

    app.route('/me')
        .get(meHandler.getMe);

    app.route('/me/nics')
        .get(meHandler.getNics);

    app.route('/me/tincd')
        .get(meHandler.getTincd);

    app.route('/me/tincd/log')
        .get(meHandler.getTincdLog);

    app.route('/me/tincd/stats')
        .post(meHandler.signalTincdStats);

    app.route('/me/iperf')
        .get(meHandler.getIperf);

    app.route('/me/iperf/start')
        .post(meHandler.startIperf);

    app.route('/me/iperf/log')
        .get(meHandler.getIperfLog);
};

