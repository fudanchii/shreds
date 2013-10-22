(function (Shreds) {
  var name = 'assets';
  var assets = {};
  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {},
    add: function (name, path) {
      assets[name] = path;
      return this;
    },
    path: function (name) { return assets[name]; },
    url:  function (name) { return 'url(' + assets[name] + ')'; }
  };
})(window.Shreds);
