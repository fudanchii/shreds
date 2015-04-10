import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';

const SubscriptionStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
    ]);
  }
});

export default SubscriptionStore;
