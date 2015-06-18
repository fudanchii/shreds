import agave from 'framework/helpers/agave';

export default
class Service {
  constructor(obj = {}) {
    this.dispatchTokens = {};
    this.respondToRoutes= [];
    obj.forEach((k, v) => {
      if (kind(v) === 'Function') {
        this[k] = v.bind(this);
      } else this[k] = v;
    });
    if (kind(this.oninit) === 'Function') {
      this.oninit();
    }
  }

  routeHandler(theFn) {
    return (payload) => {
      if (this.respondToRoutes.indexOf(payload.route.name) >= 0) {
        theFn.call(this, payload);
      }
    }
  }

  regDispatcher(dispatcher, entries) {
    entries.forEach((entry) => {
      this.dispatchTokens[entry[0]] = dispatcher.register.apply(dispatcher, entry);
    });
  }
}
