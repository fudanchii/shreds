import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import { event } from 'shreds/constants';

const FeedsStore = new Store({
  respondToRoutes: ['feeds'],
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED, this.routeHandler(this.navigated)]
    ]);
  },

  navigated(payload) {
    payload.data.$_rerender = true;
    this.refresh(payload.data);
    this.emitChange();
  }
});

export default FeedsStore;
