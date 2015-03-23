import $ from 'jquery';

import Service from 'framework/service';
import { event } from 'framework/helpers/constants';

export default
class Store extends Service {
  constructor(opts) {
    super(opts);
    this.sandbox = $({});
  }

  addChangeListener(callback) {
    this.sandbox.on(event.CHANGE, callback);
  }

  emitChange() {
    this.sandbox.trigger(event.CHANGE, this.__data);
  }

  removeChangeListener(callback) {
    this.sandbox.off(event.CHANGE, callback);
  }

  preload(data) {
    this.__data = data;
  }

  getData(arg) {
    if (arg) {
      return this.__data[arg];
    }
    return this.__data;
  }
}
