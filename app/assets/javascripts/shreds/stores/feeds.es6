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
    let feed = _.find(this.get('feeds'), item => item.id === payload.fid);
    if (feed) {
      feed.articles.forEach(article => {
        article.unread = false;
      });
    }
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    let feed = _.find(this.get('feeds'), item => item.id === payload.data.fid);
    if (feed) {
      let article = _.find(feed.articles, item => item.id === payload.data.nid);
      if (article) {
        article.unread = !article.unread;
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
