import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const SubscriptionStore = new Store({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.COLLAPSE_SUBSCRIPTION_FORM, this.collapseForm],
      [action.SUBSCRIBE_TO_FEED,          this.uncollapseForm],
      [action.FAIL_NOTIFY,                this.failHandler],
      [action.STOP_SUBSCRIBE_SPINNER,     this.feedSubscribed],
      [action.START_UPLOAD_SPINNER,       this.startUploadSpinner],
      [action.STOP_UPLOAD_SPINNER,        this.stopUploadSpinner]
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
  },

  startUploadSpinner() {
    this.set('uploadSpinnerStarted', true);
    this.emitChange();
  },

  stopUploadSpinner() {
    this.set('uploadSpinnerStarted', false);
    this.emitChange();
  }
});

export default SubscriptionStore;
