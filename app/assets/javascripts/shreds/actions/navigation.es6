import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const NavigationActions = {
  navigate(path, cid, fid) {
    ShredsDispatcher.dispatch({
      type: action.NAVIGATE,
      cid, fid, path
    });
  },

  markAsRead(cid, fid) {
    ShredsDispatcher.dispatch({
      type: action.MARK_FEED_AS_READ,
      cid, fid
    });
  }
};

export default NavigationActions;
