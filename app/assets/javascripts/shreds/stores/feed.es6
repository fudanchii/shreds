import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const FeedStore = new Store({
  respondToRoutes: ['feeds/show', 'feeds/show/page'],

  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED, this.routeHandler(this.navigated)]
    ]);
  },

  navigated(payload) {
    const __this = this;
    ShredsAppStore.load({ toDisplay: 'feed' });
    ShredsAppStore.emitChange({
      callable() {
        __this.refresh(payload.data);
        __this.emitChange();
      }
    });
  }
});

export default FeedStore;
