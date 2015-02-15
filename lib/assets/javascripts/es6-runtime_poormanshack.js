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
  var resolved_deps, context;

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

  context = factory.apply(null, resolved_deps);
  if (deps[0] === 'exports') {
    // ditch context, it gets replaced here
    context = {};
    for (var item in exports) {
      context[item] = exports[item];
      delete exports[item];
    }
  }
  if (context !== undefined && name !== '') {
    require.shim[name] = context;
  } else if (name === '' && context.constructor === Object) {
    for (var item in context) {
      require.shim[item.toLowerCase()] = context[item];
    }
  }
}

define.amd = {};
