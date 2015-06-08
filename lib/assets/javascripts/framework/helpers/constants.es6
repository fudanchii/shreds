//= require framework/helpers/path

import { join } from 'framework/helpers/path';

function addItem(obj) {
  return function (/*arguments*/) {
    return Array.prototype.reduce.call(arguments, (p, c, i, a) => {
      obj[c] = c.toHash();
      return obj;
    }, obj);
  }
}

export const action = {
  NAVIGATE_TO_ROUTE: 'NAVIGATE_TO_ROUTE'.toHash()
}

export const event = {
  CHANGE: 'CHANGE',
  ROUTE_NAVIGATED: 'ROUTE_NAVIGATED'.toHash()
};

export const defActions = addItem(action);

export const defEvents = addItem(event);
