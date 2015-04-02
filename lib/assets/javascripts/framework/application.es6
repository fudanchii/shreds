import Component from 'framework/component';

export default class Application {
  constructor(mainComponent, options = {}) {
    this.options = options;
    this.name = options.name || 'app';
    this.debug = options.debug || false;
    this.main = {
      Class: mainComponent,
      Instance: null
    };
  }

  init() {
    this.components = {};
    this.initComponents();
  }

  initComponents() {
    Component.loader({ prefix: this.name });
    this.main.Instance = new this.main.Class();
    Component.prototype.parent = this.main.Instance;
    for (var name in Component.components) {
      this.components[name] = { Class: Component.components[name] };
      if (this.options.prerender.includes(name)) {
        this.components[name].Instance = new this.components[name].Class();
      }
    }
  }
}
