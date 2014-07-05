(function (Shreds) { 'use strict';
  var assets = {};
  Shreds.registerComponent('assets', {
    init: function () {},
    add: function (name, path) {
      assets[name] = path;
      return this;
    },
    path: function (name) { return assets[name]; },
    url:  function (name) { return 'url(' + assets[name] + ')'; }
  });
})(window.Shreds);
