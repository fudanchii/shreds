import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const FeedsStore = new Store({
  respondToRoutes: ['feeds'],
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED, this.routeHandler(this.navigated)]
    ]);
  },

  navigated(payload) {
    ShredsAppStore.load({ toDisplay: 'feeds' });
    ShredsAppStore.emitChange();
    this.refresh(payload.data);
    this.emitChange({ rerender: true });
  }
});

export default FeedsStore;
