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

  getFeed(cid, fid) {
    return this.__data.categories[cid].feeds[fid];
  },

  navigate(payload) {
    let selected = this.__data.selected || (
      this.__data.selected = { cid: null, fid: null }
      );
    if (selected.cid && selected.fid) {
      const selectedFeed = this.getFeed(selected.cid, selected.fid);
      selectedFeed.active = '';
    } else {
      this.__data.categories.forEach(category => {
        for (var f in category.feeds) { category.feeds[f].active = ''; }
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
    this.__data.__favicons || (this.__data.__favicons = {});
    const
      favicons = this.__data.__favicons,
      feed = this.getFeed(payload.cid, payload.fid),
      key = `${payload.cid}:${payload.fid}`;
    if (!favicons[key]) {
      favicons[key] = feed.favicon;
    }
    feed.favicon = AssetsStore.getData('spinner16x16');
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
    feed.favicon = this.__data.__favicons[key];
  },

  reloadNavigation(payload) {
    this.refresh(payload.data.data);
    this.emitChange();
  }
});

export default NavigationStore;
