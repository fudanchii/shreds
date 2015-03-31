import Component from 'framework/component';

export default class Application {
  constructor(options) {
    this.name = options.name || `app-${GUID.next()}`;
    this.debug = options.debug || false;
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
