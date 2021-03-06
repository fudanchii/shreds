import $ from 'jquery';

import Service from 'framework/service';
import { event } from 'framework/helpers/constants';

export default
class Store extends Service {
  constructor(opts) {
    super(opts);
    this.sandbox = $({});
    this.__data = {};
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
    this.__data || (this.__data = {});
    this.__data[key] = value;
  }

  refresh(data) {
    for (var key in this.__data) {
      if (_.isFunction(this.__data[key])) {
        continue;
      }
      delete this.__data[key];
    }
    this.load(data);
  }

  get(arg /*, options */) {
    let options = arguments[1] || {};
    if (arg) {
      if (options.createIfUndefined && _.isUndefined(this.__data[arg])) {
        this.__data[arg] = {};
      }
      return this.__data[arg];
    }
    return this.__data;
  }

  getOrCreate(arg) {
    return this.get(arg, { createIfUndefined: true });
  }
}
