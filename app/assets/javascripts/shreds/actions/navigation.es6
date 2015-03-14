import ActionDispatcher from 'framework/action';

import { action } from 'shreds/constants';

const NavigationActions = {
  dispatcher: new ActionDispatcher(),

  navigate(cid, fid) {
    this.dispatcher.dispatch({
      type: action.NAVIGATE,
      cid: cid,
      fid: fid
    });
  },

  markAsRead(id) {
    this.dispatcher.dispatch({
      type: action.MARK_FEED_AS_READ,
      id: id
    });
  }
};

export default NavigationActions;
