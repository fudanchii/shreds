(function ($, History) {
  'use strict';

  var $anchor = null;

  var debug = false;

  var on_dispatch = null;

  var link_selector = 'a[target!=_blank]:not([href^=http]):not([href^=javascript])';

  this.Router = function Router(options) {
    var _this = this;
    this.routes = [];

    $anchor = options.anchor || null;
    debug   = options.debug  || false;
    link_selector = options.selector || link_selector;
    on_dispatch = options.on_dispatch || null;

    History.Adapter.bind(window, 'statechange', function (ev) {
      _this.dispatch();
      ev.preventDefault();
      ev.stopPropagation();
    });

    $(document).on('click', link_selector, function (ev) {
      _this.navigate($(this).attr('href'));
      ev.preventDefault();
      ev.stopPropagation();
    });
  };

  this.Router.prototype = {

    define: function define(path, action) {
      var route = {
        pattern: new RegExp('^' + path.replace(/\//g, '\\/').replace(/:[\w]+/g, '([^\\/#\\?]+)') + '(\\/?(?:[#\\?]).*)?$'),
        vars: parseVars(path),
        action: action
      };
      log('defined: ', route);
      this.routes.push(route);
    },

    dispatch: function dispatch() {
      var action = null, data = {};
      var state = History.getState();
      log('state: ', state.hash);
      for (var i in this.routes) {
        var args = state.hash.match(this.routes[i].pattern);
        if (args instanceof Array && args.shift()) {
          log('matched: ', this.routes[i]);
          for (var name in this.routes[i].vars) {
            data[this.routes[i].vars[name]] = args[name];
          }
          execute(this.routes[i].action, data);
          return;
        }
      }
      log('No matched route.');
    },

    navigate: function navigate(path) {
      log(this, path);
      History.pushState({}, '...', path);
    }

  };


  function execute(action, data) {
    switch (typeof action) {
    case 'string':
      $anchor.trigger(action, data);
      break;
    case 'function':
      action(data);
      break;
    default:
      log('Can\'t dispatch action : ', action, data);
    }
    if (typeof on_dispatch === 'string') {
      $anchor.trigger(on_dispatch, data);
    }
  }

  function log() {
    if (debug) { console.log('Router : ', arguments); }
  }

  function parseVars(path) {
    var match = path.match(/(:[^\W\/#\?]+)/g);
    return (match || []).map(function (el) {
      return el.replace(/:/g, '');
    });
  }

}).call(window, window.jQuery, window.History);
