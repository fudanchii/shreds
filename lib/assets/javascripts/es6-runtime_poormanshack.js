var exports, require, define, module;

exports = function(){};
module = { exports: null };

require = function (m) {
  return require.s.contexts._.defined[m] || (function (name, def) {

    if (!def) { return; }

    def.args.forEach(function (c, i, a) {
      if (c === undefined) {
        a[i] = require(def.deps[i]);
      }
    });

    var context = def.factory.apply(null, def.args);

    // resolve module.exports with module id
    if (def.deps[1] === 'module' && name !== '') {
      require.s.contexts._.defined[name] = module.exports;
      delete module['exports'];
      module.exports = null;
    }
  
    // resolve export when exports is an object,
    // iterate exported item and move them to context object.
    else if (def.deps[0] === 'exports') {
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
      require.s.contexts._.defined[name] = context;
    }

    delete require.s.contexts._.registry[name];

    return require.s.contexts._.defined[name];
  })(m, require.s.contexts._.registry[m]) || window[m];
};

require.s = {
  contexts: {
    '_': {
      registry: {},
      defined: {
        'jquery': window.jQuery,
        'history': window.History
//        'babel-runtime/core-js': { default: window.core }
      }
    }
  }
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

  if (name === '') {
    // throw "Can't resolve anonymous module";
    return;
  }

  require.s.contexts._.registry[name] = {
    factory: factory,
    deps: deps,
    args: resolved_deps
  };
};

define.amd = {};

module.loadNamespace = function (namespace, callback) {
  var
    modules = require.s.contexts._,
    rgx = new RegExp('^' + namespace + '/'),
    result = [];

  for (var k in modules.defined) {
    if (rgx.test(k)) {
      result.push({
        Name: k,
        Class: modules.defined[k]
      });
    }
  }

  for (var k in modules.registry) {
    if (rgx.test(k)) {
      result.push({
        Name: k,
        Class: require(k)
      });
    }
  }

  if (typeof(callback) === 'function') {
    callback(result);
  }
};
