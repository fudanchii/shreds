import $ from 'jquery';
import History from 'history';

import Service from 'framework/service';
import { action } from 'framework/helpers/constants';
import { join } from 'framework/helpers/path';

const anchor_selector = 'a[href^=\\/]:not([target=_blank])';

export default
class Router extends Service {
  constructor(opts) {
    this.staticRouteMap = {};
    this.varsRouteMap = {};
    History.Adapter.bind(window, 'statechange', this.dispatch.bind(this));
    $(document).on('click', anchor_selector, ev => {
      ev.preventDefault();
      ev.stopPropagation();
      this.navigate($(ev.currentTarget).attr('href'));
    });
    super(opts);
  }

  map(fn) {
    fn.call(this, this.addRoute.bind(this));
  }

  addRoute(name, props, fn) {
    let path = join('/', name),
        rpath = '';
    if (props instanceof Object && props.path) {
      path = props.path;
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
    if (typeof props.path === 'string' && props.path[0] !== '/') {
      props.path = join(ppath, props.path);
    }
    this.addRoute(join(pname, name), props, fn);
  }

  addStaticRouteMap(name, path) {
    this.staticRouteMap[path] = true;
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

  navigate(path) {
    History.pushState({}, '···', path);
  }

  dispatch() {
    const state = History.getState(),
          stateHash = state.hash.split('?')[0];

    // dispatch static routes
    if (this.staticRouteMap[stateHash]) {
      this.dispatcher.dispatch({
        type: action.NAVIGATE_TO_ROUTE,
        path: stateHash
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
          type: action.NAVIGATE_TO_ROUTE,
          path: stateHash,
          data: data
        }); return;
      }
    }
  }
}
