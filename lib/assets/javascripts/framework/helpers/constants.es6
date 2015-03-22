//= require framework/helpers/path

import { join } from 'framework/helpers/path';

export const event = {
  CHANGE: 'fwx:change'
};

export const routeActionEvent = function (...names) {
  return `fwx:routes:${join.apply(null, names)}`;
}
