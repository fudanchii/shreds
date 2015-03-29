import agave from 'framework/helpers/agave';

export default
class Service {
  constructor(obj) {
    this.dispatchTokens = {};
    for (var keys in obj) {
      if (obj[keys] instanceof Function) {
        this[keys] = obj[keys].bind(this);
        continue;
      }
      this[keys] = obj[keys];
    }
    if (this.oninit instanceof Function) {
      this.oninit();
    }
  }

  routeHandler(theFn) {
    return (payload) => {
      if (this.respondToRoutes.includes(payload.route.name)) {
        // fade in
        theFn.call(this, payload);
        return;
      }
      // fade out
      return;
    }
  }

  regDispatcher(dispatcher, entries) {
    entries.forEach((entry) => {
      this.dispatchTokens[entry[0]] = dispatcher.register.apply(dispatcher, entry);
    });
  }
}
