import Component from 'framework/component';

import { join } from 'framework/helpers/path';

export default class Application {
  constructor(mainComponent, options = {}) {
    this.options = options;
    this.name = options.name || 'app';
    this.main = { Class: mainComponent };
  }

  init(debug) {
    Component.setup({ prefix: this.name, debug });
    module.loadNamespace(join(this.name, 'services'));
    module.loadNamespace(join(this.name, 'decorators'));
    Component.loader();
    this.initComponents();
  }

  initComponents() {
    this.components = {};
    this.main.Instance = new this.main.Class();
    Component.prototype.parent = this.main.Instance;
    for (var name in Component.components) {
      this.components[name] = { Class: Component.components[name] };
      if (_.includes(this.options.prerender, name)) {
        this.components[name].Instance = new this.components[name].Class();
      }
    }
  }
}
