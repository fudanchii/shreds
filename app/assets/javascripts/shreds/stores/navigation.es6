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
      [event.FEED_MARKED_AS_READ, this.feedMarkedAsRead]
    ]);
  },

  getFeed(cid, fid) {
    return this.__data.categories[cid].feeds[fid];
  },

  navigate(payload) {
    let selected = this.__data.selected;
    if (selected.cid && selected.fid) {
      const selectedFeed = this.getFeed(selected.cid, selected.fid);
      selectedFeed.active = '';
    }
    const feed = this.getFeed(payload.cid, payload.fid);
    feed.active = ' active';
    selected.cid = payload.cid;
    selected.fid = payload.fid;
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

  feedMarkedAsRead(payload) {
    const
      f = payload.data.feed,
      feed = this.getFeed(f.categoryId, f.id);
    this.restoreFavicon(f.categoryId, f.id);
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
  }
});

export default NavigationStore;
