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

    this.__data = { newsitems: [] };
  },

  feedMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      newsitems = this.__data.newsitems;
    if (this.__data.id !== f.id) {
      return;
    }
    newsitems.forEach(newsitem => {
      newsitem.unread = false;
    });
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      newsitems = this.__data.newsitems;
    let newsitem = newsitems.findItem(item => item.id === f.nid);
    if (newsitem) {
      newsitem.unread = !newsitem.unread;
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
