import Store from 'framework/store';

import AssetsStore from 'shreds/stores/assets';
import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const NavigationStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.NAVIGATE,           [], this.navigate],
      [action.MARK_FEED_AS_READ,  [], this.markFeedAsRead],
      [action.FAIL_NOTIFY,        [], this.failHandler],
      [event.FEED_MARKED_AS_READ, [], this.feedMarkedAsRead]
    ]);
  },

  navigate(payload) {
    let selected = this.__data.selected;
    if (selected.cid && selected.fid) {
      this.__data.categories[selected.cid].feeds[selected.fid].active = '';
    }
    this.__data.categories[payload.cid].feeds[payload.fid].active = ' active';
    selected.cid = payload.cid;
    selected.fid = payload.fid;
    this.emitChange();
  },

  markFeedAsRead(payload) {
    this.__data.__favicons || (this.__data.__favicons = {});
    const
      favicons = this.__data.__favicons,
      key = `${payload.cid}:${payload.fid}`;
    if (!favicons[key]) {
      favicons[key] = this.__data.categories[payload.cid].feeds[payload.fid].favicon;
    }
    this.__data.categories[payload.cid].feeds[payload.fid].favicon = AssetsStore.getData('spinner16x16');
    this.emitChange();
  },

  feedMarkedAsRead(payload) {
    const f = payload.data.feed;
    this.restoreFavicon(f.categoryId, f.id);
    this.__data.categories[f.categoryId].feeds[f.id].unreadCount = f.unreadCount;
    this.emitChange();
  },

  failHandler(payload) {
    this.restoreFavicon(payload.data.cid, payload.data.fid);
    this.emitChange();
  },

  restoreFavicon(cid, fid) {
    const key = `${cid}:${fid}`;
    this.__data.categories[cid].feeds[fid].favicon = this.__data.__favicons[key];
  }
});

export default NavigationStore;
