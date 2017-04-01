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

    this.set('articles', []);
  },

  feedMarkedAsRead(payload) {
    if (this.get('subscription_id') !== payload.data.sid) {
      return;
    }
    this.get('articles').forEach(article => {
      article.unread = false;
    });
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    let article = _.find(this.get('articles'), item => item.id === payload.data.nid);
    if (article) {
      article.unread = !article.unread;
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
