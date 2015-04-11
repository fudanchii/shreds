import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const SubscriptionActions = {
  collapse() {
    ShredsDispatcher.dispatch({ type: action.COLLAPSE_SUBSCRIPTION_FORM });
  },

  subscribe(form) {
    ShredsDispatcher.dispatch({
      type: action.SUBSCRIBE_TO_FEED,
      form
    });
  }
};

export default SubscriptionActions;
