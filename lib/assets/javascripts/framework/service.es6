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

  regDispatcher(dispatcher, entries) {
    entries.forEach((entry) => {
      this.dispatchTokens[entry[0]] = dispatcher.register.apply(dispatcher, entry);
    });
  }
}
