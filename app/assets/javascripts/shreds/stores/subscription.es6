import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const SubscriptionStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.COLLAPSE_SUBSCRIPTION_FORM, this.collapseForm]
    ]);
  },

  collapseForm() {
    this.set('collapsed', true);
    this.emitChange();
  }
});

export default SubscriptionStore;
