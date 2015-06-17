import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const SubscriptionActions = {
  collapse() {
    ShredsDispatcher.dispatch({ type: action.COLLAPSE_SUBSCRIPTION_FORM });
  },

  uncollapse() {
    ShredsDispatcher.dispatch({ type: action.UNCOLLAPSE_SUBSCRIPTION_FORM });
  },

  subscribe(form) {
    ShredsDispatcher.dispatch({
      type: action.SUBSCRIBE_TO_FEED,
      form
    });
  },

  stopSubscribeSpinner() {
    ShredsDispatcher.dispatch({
      type: action.STOP_SUBSCRIBE_SPINNER
    });
  },

  startUploadSpinner() {
    ShredsDispatcher.dispatch({
      type: action.START_UPLOAD_SPINNER
    });
  },

  stopUploadSpinner() {
    ShredsDispatcher.dispatch({
      type: action.STOP_UPLOAD_SPINNER
    });
  },

  opmlUploaded(data) {
    ShredsDispatcher.dispatch({
      type: event.OPML_UPLOADED,
      data
    });
  }
};

export default SubscriptionActions;
