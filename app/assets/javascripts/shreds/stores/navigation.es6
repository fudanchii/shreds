import moment from 'moment';

import Store from 'framework/store';

import AssetsStore from 'shreds/stores/assets';
import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const NavigationStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.NAVIGATE_TO_ROUTE,  this.navigate],
      [action.MARK_FEED_AS_READ,  this.markFeedAsRead],
      [action.FAIL_NOTIFY,        this.failHandler],
      [action.RELOAD_NAVIGATION,  this.reloadNavigation],
      [event.FEED_MARKED_AS_READ, this.feedMarkedAsRead],
      [event.ITEM_MARKED_AS_READ, this.itemMarkedAsRead]
    ]);
  },

  emitChange() {
    this.formatEntriesPubDate();
    this._super.emitChange();
  },

  formatEntriesPubDate() {
    const categories = this.get('categories') || {};
    _.each(categories, (category, k) => {
      _.each(category.subscriptions, (feed, k) => {
        feed.momentFmtEntryPubDate = moment(feed.latest_article.published).fromNow(true);
      });
    });
  },

  getFeed(cid, sid) {
    return this.get('categories')[cid].subscriptions[sid];
  },

  navigate(payload) {
    const
      map = this.getOrCreate('__feed-category_map'),
      prefix = '/' + payload.path.split('/')[1];
    if (payload.args && payload.args.cid && payload.args.sid) {
      map[prefix] = { cid: payload.args.cid, fid: payload.args.sid };
    } else if (map[prefix]) {
      payload.args = map[prefix];
    }
    this.setActiveFeedItem(payload);
  },

  setActiveFeedItem(payload) {
    const
      data = this.get(),
      args = payload.args;
    let selected = data.selected || (
      data.selected = { cid: null, sid: null }
      );
    if (selected.cid && selected.sid) {
      const selectedFeed = this.getFeed(selected.cid, selected.sid);
      selectedFeed.active = '';
    } else {
      _.each(this.get('categories'), (category, k) => {
        _.each(category.subscriptions, (feed, k) => { feed.active = ''; });
      });
    }
    if (args.cid && args.sid) {
      const feed = this.getFeed(args.cid, args.sid);
      feed.active = ' active';
      selected.cid = args.cid;
      selected.sid = args.sid;
    }
    this.emitChange();
  },

  markFeedAsRead(payload) {
    const
      favicons = this.getOrCreate('__favicons'),
      feed = this.getFeed(payload.cid, payload.sid),
      key = `${payload.cid}:${payload.sid}`;
    if (!favicons[key]) {
      favicons[key] = feed.feed_icon;
    }
    feed.feed_icon = AssetsStore.get('spinner16x16');
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    const
      f = payload.data.subscription,
      feed = this.getFeed(f.category_id, f.id);
    feed.unread_count = f.unread_count;
    this.emitChange();
  },

  feedMarkedAsRead(payload) {
    const
      f = payload.data.subscription,
      feed = this.getFeed(f.category_id, f.id);
    this.restoreFeedIcon(f.category_id, f.id);
    feed.unread_count = f.unread_count;
    this.emitChange();
  },

  failHandler(payload) {
    switch (payload.data.type) {
    case action.MARK_FEED_AS_READ:
      this.restoreFavicon(payload.data.cid, payload.data.sid);
      break;
    }
    this.emitChange();
  },

  restoreFeedIcon(cid, sid) {
    const
      key = `${cid}:${sid}`,
      feed = this.getFeed(cid, sid);
    feed.feed_icon = this.get('__favicons')[key];
  },

  reloadNavigation(payload) {
    const
      selected = this.get('selected');
    this.refresh(payload.data.data);
    this.setActiveFeedItem({ args: selected });
    this.emitChange();
  }
});

export default NavigationStore;
