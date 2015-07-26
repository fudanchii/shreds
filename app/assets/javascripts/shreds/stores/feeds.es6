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

    this.set('feeds', []);
  },

  feedMarkedAsRead(payload) {
    const f = payload.data.feed;
    let feed = _.find(this.get('feeds'), item => item.id === f.id);
    if (feed) {
      feed.newsitems.forEach(newsitem => {
        newsitem.unread = false;
      });
    }
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    const f = payload.data.feed;
    let feed = _.find(this.get('feeds'), item => item.id === f.id);
    if (feed) {
      let newsitem = _find(feed.newsitems, item => item.id === f.nid);
      if (newsitem) {
        newsitem.unread = !newsitem.unread;
      }
    }
    this.emitChange();
  },

  navigated(payload) {
    ShredsAppStore.viewChange('feeds', () => {
      this.refresh(payload.data);
      this.emitChange('feeds');
    });
  }
});

export default FeedsStore;
