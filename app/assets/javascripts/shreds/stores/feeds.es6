import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const FeedsStore = new Store({
  respondToRoutes: ['feeds', 'feeds/page'],

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
      feeds = this.__data.feeds;
    for (var i in feeds) {
      if (feeds[i].id === f.id) {
        for (var j in feeds[i].newsitems) {
          feeds[i].newsitems[j].unread = false;
        }
        break;
      }
    }
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      feeds = this.__data.feeds;
    for (var i in feeds) {
      if (feeds[i].id === f.id) {
        for (var j in feeds[i].newsitems) {
          if (feeds[i].newsitems[j].id === f.nid) {
            feeds[i].newsitems[j].unread = !feeds[i].newsitems[j].unread;
            this.emitChange();
            return;
          }
        }
      }
    }
  },

  navigated(payload) {
    ShredsAppStore.viewChange('feeds', () => {
      this.refresh(payload.data);
      this.emitChange('feeds');
    });
  }
});

export default FeedsStore;
