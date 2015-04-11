import $ from 'jquery';

import Service from 'framework/service';
import { event } from 'framework/helpers/constants';

export default
class Store extends Service {
  constructor(opts) {
    this.sandbox = $({});
    this.__data = {};
    super(opts);
  }

  addChangeListener(callback) {
    this.sandbox.on(event.CHANGE, callback);
  }

  emitChange(meta) {
    this.sandbox.trigger(event.CHANGE, {
      data: this.__data,
      meta
    });
  }

  removeChangeListener(callback) {
    this.sandbox.off(event.CHANGE, callback);
  }

  preload(data) {
    this.__data = data;
  }

  load(data) {
    Object.assign(this.__data, data);
  }

  set(key, value) {
    this.__data[key] = value;
  }

  refresh(data) {
    for (var key in this.__data) {
      if (kind(this.__data[key]) === 'Function') {
        continue;
      }
      delete this.__data[key];
    }
    this.load(data);
  }

  getData(arg) {
    if (arg) {
      return this.__data[arg];
    }
    return this.__data;
  }
}
