import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const NavigationActions = {
  navigate(path, cid, fid) {
    ShredsDispatcher.dispatch({
      type: action.NAVIGATE,
      cid: cid,
      fid: fid,
      path: path
    });
  },

  markAsRead(cid, fid) {
    ShredsDispatcher.dispatch({
      type: action.MARK_FEED_AS_READ,
      cid: cid,
      fid: fid
    });
  }
};

export default NavigationActions;
