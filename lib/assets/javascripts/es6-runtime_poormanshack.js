var exports, require, define, module;

exports = function(){};
module = { exports: null };

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

  // resolve module.exports with module id
  if (deps[1] === 'module' && name !== '') {
    require.shim[name] = module.exports;
    delete module['exports'];
    module.exports = null;
  }
  
  // resolve export when exports is an object,
  // iterate exported item and move them to context object.
  else if (deps[0] === 'exports') {
    // ditch context, it gets replaced here
    context = {};
    for (var item in exports) {
      context[item] = exports[item];
      delete exports[item];
    }
  }

  // resolve export when factory returns data and
  // module didn't use exports or module.exports
  // and module has module id
  if (context !== undefined && name !== '') {
    require.shim[name] = context;
  }
  
  // This AMD loader wont work with dynamically loaded javascript libraries,
  // and can't resolve module without id.
  else if (name === '') {
    throw "Can't resolve anonymous module";
  }
}

define.amd = {};
