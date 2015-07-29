
export default
class Service {
  constructor(obj = {}) {
    this.dispatchTokens = {};
    this.respondToRoutes= [];
    this._super = {};
    _.each(obj, (v, k) => {
      if (_.isFunction(v)) {
        this[k] && (this._super[k] = this[k].bind(this));
        this[k] = v.bind(this);
      } else this[k] = v;
    });
    if (_.isFunction(this.oninit)) {
      this.oninit();
    }
  }

  routeHandler(theFn) {
    return (payload) => {
      if (_.includes(this.respondToRoutes, payload.route.name)) {
        theFn.call(this, payload);
      }
    }
  }

  regDispatcher(dispatcher, entries) {
    _.each(entries, (entry) => {
      this.dispatchTokens[entry[0]] = dispatcher.register.apply(dispatcher, entry);
    });
  }
}
