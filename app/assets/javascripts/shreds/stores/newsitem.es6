import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const NavigationStore = new Store({
  respondToRoutes: ['feeds/showNewsitem'],
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED,     this.routeHandler(this.navigated)],
      [event.ITEM_MARKED_AS_READ, this.itemMarkedAsRead],
      [event.FEED_MARKED_AS_READ, this.feedMarkedAsRead]
    ]);
  },

  itemMarkedAsRead(payload) {
    this.__data.unread = !this.__data.unread;
    this.emitChange();
  },

  feedMarkedAsRead(payload) {
    if (payload.data.feed.id === this.__data.fid) {
      this.__data.unread = false;
      this.emitChange();
    }
  },

  navigated(payload) {
    ShredsAppStore.viewChange('newsitem', () => {
      this.refresh(payload.data);
      this.emitChange();
    });
  }
});

export default NavigationStore;
