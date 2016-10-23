import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const FeedActions = {
  markAsRead(cid, sid, fid, nid, unread) {
    ShredsDispatcher.dispatch({
      type: action.MARK_ITEM_AS_READ,
      cid, sid, fid, nid, unread
    });
  }
};

export default FeedActions;
