import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const FeedActions = {
  markAsRead(fid, nid) {
    ShredsDispatcher.dispatch({
      type: action.MARK_ITEM_AS_READ,
      fid, nid
    });
  }
};

export default FeedActions;
