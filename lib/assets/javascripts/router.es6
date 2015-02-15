import $ from "jquery";
import History from "history";

var debug, $anchor, on_dispatch;
let link_selector = 'a[target!=_blank]:not([href^=http]):not([href^=javascript])';

export class Router {
  constructor(opts) {
    debug = opts.debug || false;
    $anchor = opts.anchor || null;
    on_dispatch = opts.on_dispatch || null;

    this.routes = [];

    History.Adapter.bind(window, 'statechange', (ev) => {
      this.dispatch();
      ev.preventDefault();
      ev.stopPropagation();
    });

    $(document).on('click', link_selector, (ev) => {
      this.navigate($(ev.currentTarget).attr('href'));
      ev.preventDefault();
      ev.stopPropagation();
    });
  }

  map(path, action) {
    let rpath = path.replace(/\//g, '\\/').replace(/:[\w]+/g, '([^\\/#\\?]+)');
    let route = {
      pattern: new RegExp('^' + rpath + '(\\/?(?:[#\\?]).*)?$'),
      vars: parseVars(path),
      action: action
    };
    log('mapped: ', route);
    this.routes.push(route);
  }

  navigate(path) {
    log(this, path);
    History.pushState({}, '...', path);
  }

  dispatch() {
    let state = History.getState();
    for (let i in this.routes) {
      let args = state.hash.match(this.routes[i].pattern);
      log(args);
      if (args instanceof Array && args.shift()) {
        log('matched: ', this.routes[i], args);
        let data = this.routes[i].vars.reduce((p, c, i, a) => {
          p[c] = args[i];
          return p;
        }, {});
        execute(this.routes[i].action, data);
        return;
      }
    }
  }
}

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
  let match = path.match(/(:[^\W\/#\?]+)/g);
  return (match || []).map((el) => el.replace(/:/g, ''));
}

