import Component from 'framework/component';

export default class Application {
  constructor(mainComponent, options = {}) {
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
      this.components[name] = new Component.components[name]();
    }
  }
}
