import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const FeedsActions = {
  markAsRead(cid, fid) {
    ShredsDispatcher.dispatch({
      type: action.MARK_FEED_AS_READ,
      cid, fid
    });
  }
};

export default FeedsActions;
