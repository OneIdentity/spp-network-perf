'use strict';

module.exports = function(app) {
  var perfTest = require('../controllers/perfController');

  app.route('/perf/:nodeId')
    .get(perfTest.testSpeed);
};

