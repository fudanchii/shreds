import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const SubscriptionStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.COLLAPSE_SUBSCRIPTION_FORM, this.collapseForm],
      [action.SUBSCRIBE_TO_FEED, this.uncollapseForm]
    ]);
  },

  collapseForm() {
    this.set('collapsed', true);
    this.emitChange();
  },

  uncollapseForm() {
    this.set('collapsed', false);
    this.emitChange();
  }
});

export default SubscriptionStore;
