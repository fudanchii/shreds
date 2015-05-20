import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const SubscriptionStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.COLLAPSE_SUBSCRIPTION_FORM, this.collapseForm],
      [action.SUBSCRIBE_TO_FEED,          this.uncollapseForm],
      [action.FAIL_NOTIFY,                this.failHandler],
      [event.FEED_SUBSCRIBED,             this.feedSubscribed]
    ]);
  },

  collapseForm() {
    this.set('collapsed', true);
    this.emitChange();
  },

  uncollapseForm() {
    this.set('collapsed', false);
    this.set('spinnerStarted', true);
    this.emitChange();
  },

  failHandler(payload) {
    switch (payload.data.type) {
    case action.SUBSCRIBE_TO_FEED:
      this.set('spinnerStarted', false);
      break;
    }
    this.emitChange();
  },

  feedSubscribed() {
    this.set('spinnerStarted', false);
    this.emitChange();
  }
});

export default SubscriptionStore;
