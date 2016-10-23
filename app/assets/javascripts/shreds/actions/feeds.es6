import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const FeedsActions = {
  markAsRead(cid, sid) {
    ShredsDispatcher.dispatch({
      type: action.MARK_FEED_AS_READ,
      cid, sid
    });
  }
};

export default FeedsActions;
