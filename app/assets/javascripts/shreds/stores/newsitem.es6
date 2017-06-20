import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const NavigationStore = new Store({
  respondToRoutes: ['feeds/show/newsitem'],
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED,     this.routeHandler(this.navigated)],
      [event.ITEM_MARKED_AS_READ, this.itemMarkedAsRead],
      [event.FEED_MARKED_AS_READ, this.feedMarkedAsRead]
    ]);
  },

  itemMarkedAsRead(payload) {
    this.set('unread', !this.get('unread'));
    this.emitChange();
  },

  feedMarkedAsRead(payload) {
    if (payload.data.sid === this.get('subscription_id')) {
      this.set('unread', false);
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
