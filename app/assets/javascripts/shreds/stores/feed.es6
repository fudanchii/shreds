import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const FeedStore = new Store({
  respondToRoutes: ['feeds/show', 'feeds/show/page'],

  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED,     this.routeHandler(this.navigated)],
      [event.ITEM_MARKED_AS_READ, this.itemMarkedAsRead],
      [event.FEED_MARKED_AS_READ, this.feedMarkedAsRead]
    ]);
  },

  feedMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      newsitems = this.__data.newsitems;
    if (this.__data.id !== f.id) {
      return;
    }
    for (var i in newsitems) {
      newsitems[i].unread = false;
    }
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      newsitems = this.__data.newsitems;
    for (var i in newsitems) {
      if (newsitems[i].id === f.newsItemId) {
        newsitems[i].unread = !newsitems[i].unread;
      }
    }
    this.emitChange();
  },

  navigated(payload) {
    ShredsAppStore.viewChange('feed', () => {
      this.refresh(payload.data);
      this.emitChange();
    });
  }
});

export default FeedStore;
