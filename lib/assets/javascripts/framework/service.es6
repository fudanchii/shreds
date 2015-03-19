export default
class Service {
  constructor(obj) {
    this.dispatchTokens = {};
    for (var k in obj) {
      if (obj[k] instanceof Function) {
        this[k] = obj[k].bind(this);
        continue;
      }
      this[k] = obj[k];
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
