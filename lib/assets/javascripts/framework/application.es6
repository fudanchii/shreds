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
    this.main.Instance = new this.main.Class(this.main.Class.inject());
  }

  initComponents() {
    Component.loader({ prefix: this.name });
  }
}
