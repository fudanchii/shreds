import $ from 'jquery';
import History from 'history';

import Service from 'framework/service';
import { join } from 'framework/helpers/path';

const anchor_selector = 'a[href^=\\/]:not([target=_blank])';

export default
class Router extends Service {
  constructor(opts) {
    super(opts);
    History.Adapter.bind(window, 'statechange', this.dispatch.bind(this));
    $(document).on('click', anchor_selector, ev => {
      const args = JSON.parse(ev.currentTarget.getAttribute('data-args') || '{}');
      ev.preventDefault();
      ev.stopPropagation();
      this.navigate(ev.currentTarget.getAttribute('href'), args);
    });
  }

  use(dispatcher, action) {
    this.dispatcher = dispatcher;
    this.action = action;
  }

  map(fn) {
    this.staticRouteMap || (this.staticRouteMap = {});
    this.varsRouteMap || (this.varsRouteMap = {});
    fn.call(this, this.addRoute.bind(this));
  }

  // For now, addRoute behavior is not defined
  // when name is null or arguments.length <= 1
  addRoute(name, props, fn) {
    let path = join('/', name),
        rpath = '';
    switch (arguments.length) {
    case 2:
      if (props && props.constructor === Function) {
        fn = props;
      }
    case 3:
      if (props && props.path) {
        path = props.path;
      }
    }
    rpath = path.replace(/\//g, '\\/').replace(/:[\w]+/g, '([^\\/#\\?]+)');
    if (rpath === path.replace(/\//g, '\\/')) {
      this.addStaticRouteMap(name, path);
    } else {
      this.addVarsRouteMap(name, path, rpath);
    }
    if (fn instanceof Function) {
      fn.call(this, this.addSubRoute.bind(this, name, path));
    }
  }

  addSubRoute(pname, ppath, name, props, fn) {
    if (name && name.path) {
      if (props && props.constructor === Function) {
        fn = props;
      }
      props = name;
      name = null;
    }
    if ( props && (typeof props.path === 'string') && props.path[0] !== '/' ) {
      props.path = join(ppath, props.path);
    }
    this.addRoute(join(pname, name), props, fn);
  }

  addStaticRouteMap(name, path) {
    this.staticRouteMap[path] = { name };
  }

  addVarsRouteMap(name, path, rpath) {
    this.varsRouteMap[name] = {
      pattern: new RegExp(`^${rpath}(\\/?(?:[#\\?]).*)?$`),
      vars: this.parseVars(path)
    };
  }

  parseVars(path) {
    const match = path.match(/(:[^\W\/#\?]+)/g);
    return (match || []).map((el) => el.replace(/:/g, ''));
  }

  navigate(path, args = {}) {
    History.pushState(args, '···', path);
  }

  dispatch() {
    const state = History.getState(),
          stateHash = state.hash.split('?')[0];
    // dispatch static routes
    if (this.staticRouteMap[stateHash]) {
      this.dispatcher.dispatch({
        type: this.action,
        name: this.staticRouteMap[stateHash].name,
        path: stateHash,
        args: state.data
      }); return;
    }

    // dispatch routes with args
    for (var name in this.varsRouteMap) {
      let args = stateHash.match(this.varsRouteMap[name].pattern);
      if (args instanceof Array && args.shift()) {
        const data = this.varsRouteMap[name].vars.reduce((p, c, i, a) => {
          p[c] = args[i];
          return p;
        }, {});
        this.dispatcher.dispatch({
          type: this.action,
          path: stateHash,
          args: state.data,
          name,
          data
        }); return;
      }
    }
  }
}
