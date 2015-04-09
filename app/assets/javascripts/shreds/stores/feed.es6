import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const FeedStore = new Store({
  respondToRoutes: ['feeds/show'],

  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED, this.routeHandler(this.navigated)]
    ]);
  },

  navigated(payload) {
    ShredsAppStore.load({ toDisplay: 'feed' });
    ShredsAppStore.emitChange();
    this.refresh(payload.data);
    this.emitChange();
  }
});

export default FeedStore;
