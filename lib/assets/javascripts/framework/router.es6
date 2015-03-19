import Service from 'framework/service';

export default
class Router extends Service {
  constructor(opts) {
    super(opts);
    this.routeMap = {};
  }

  map(fn) {
    fn.call(this, this.addRoute.bind(this));
  }

  addRoute(/*arguments*/) {
    let path = '/' + arguments[0];
    if (arguments[1] instanceof Object && arguments[1].path) {
      path = arguments[1].path;
    }
    this.routeMap[arguments[0]] = {
      path: path
    };
  }
}
