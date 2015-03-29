import NProgress from 'NProgress';

import Service from 'framework/service';

import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const NProgressService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.NAVIGATE_TO_ROUTE, this.start],
      [action.FAIL_NOTIFY,       this.done],
      [event.ROUTE_NAVIGATED,    this.done]
    ]);
  },

  start() {
    NProgress.start();
    NProgress.set(0.6);
  },

  done() {
    NProgress.done();
  }
});

export default NProgressService;
