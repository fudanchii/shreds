import Component from 'framework/component';

export default class Application {
  constructor(options) {
    this.name = options.name || `app-${GUID.next()}`;
    this.debug = options.debug || false;
  }

  init() {
    this.components = {};
    this.initComponents();
  }

  initComponents() {
    const components = Component.loader({ prefix: this.name });
    components.forEach((c, i, a) => {
      const
        args = [null].concat(c.Class.inject()),
        factoryFn = c.Class.bind.apply(c.Class, args);
      c.Class.addHelpers(c.Class.helpers());
      this.components[c.Name] = new factoryFn();
    });
  }

  initServices() {
    const services = Service.loader({ prefix: this.name });
    services.forEach((c, i, a) => {
    });
  }
}
