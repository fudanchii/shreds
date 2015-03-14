import $ from 'jquery';
import { ev } from 'framework/helpers/constants';

export default class Store {
  constructor() {
    this.sandbox = $({});
  }

  addChangeListener(callback) {
    this.sandbox.on(ev.CHANGE, callback);
  }

  emitChange() {
    this.sandbox.trigger(ev.CHANGE, this.__data);
  }

  removeChangeListener(callback) {
    this.sandbox.off(ev.CHANGE, callback);
  }

  preload(data) {
    this.__data = data;
  }

  getData() {
    return this.__data;
  }
}
