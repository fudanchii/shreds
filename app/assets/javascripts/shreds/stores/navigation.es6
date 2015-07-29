import moment from 'moment';

import Store from 'framework/store';

import AssetsStore from 'shreds/stores/assets';
import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const NavigationStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.NAVIGATE,           this.navigate],
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
      _.each(category.feeds, (feed, k) => {
        feed.momentFmtEntryPubDate = moment(feed.latestEntryPubDate).fromNow(true);
      });
    });
  },

  getFeed(cid, fid) {
    return this.get('categories')[cid].feeds[fid];
  },

  navigate(payload) {
    const data = this.get();
    let selected = data.selected || (
      data.selected = { cid: null, fid: null }
      );
    if (selected.cid && selected.fid) {
      const selectedFeed = this.getFeed(selected.cid, selected.fid);
      selectedFeed.active = '';
    } else {
      _.each(this.get('categories'), (category, k) => {
        _.each(category.feeds, (feed, k) => { feed.active = ''; });
      });
    }
    if (payload.cid && payload.fid) {
      const feed = this.getFeed(payload.cid, payload.fid);
      feed.active = ' active';
      selected.cid = payload.cid;
      selected.fid = payload.fid;
    }
    this.emitChange();
  },

  markFeedAsRead(payload) {
    if (_.isUndefined(this.get('__favicons'))) {
      this.set('__favicons', {});
    }
    const
      favicons = this.get('__favicons'),
      feed = this.getFeed(payload.cid, payload.fid),
      key = `${payload.cid}:${payload.fid}`;
    if (!favicons[key]) {
      favicons[key] = feed.favicon;
    }
    feed.favicon = AssetsStore.get('spinner16x16');
    this.emitChange();
  },

  itemMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      feed = this.getFeed(f.cid, f.id);
    feed.unreadCount = f.unreadCount;
    this.emitChange();
  },

  feedMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      feed = this.getFeed(f.cid, f.id);
    this.restoreFavicon(f.cid, f.id);
    feed.unreadCount = f.unreadCount;
    this.emitChange();
  },

  failHandler(payload) {
    switch (payload.data.type) {
    case action.MARK_FEED_AS_READ:
      this.restoreFavicon(payload.data.cid, payload.data.fid);
      break;
    }
    this.emitChange();
  },

  restoreFavicon(cid, fid) {
    const
      key = `${cid}:${fid}`,
      feed = this.getFeed(cid, fid);
    feed.favicon = this.get('__favicons')[key];
  },

  reloadNavigation(payload) {
    this.refresh(payload.data.data);
    this.emitChange();
  }
});

export default NavigationStore;
