var exports, require, define;

exports = function(){};

require = function (m) {
  return exports[m] || require.shim[m] || window[m];
};

require.shim = {
  'jquery': window.jQuery,
  'history': window.History
};

/*
 * Totally not resolve in async.
 * */
define = function (name, deps, factory) {
  var resolved_deps, params;

  if (arguments.length === 2) {
    factory = deps;
    deps = name;
    name = '';
  } else if (arguments.length === 1) {
    factory = name;
    deps = [];
    name = '';
  }
  resolved_deps = deps.map(function (v) {
    return require(v);
  });
  factory.apply(null, resolved_deps);
}

define.amd = {};
