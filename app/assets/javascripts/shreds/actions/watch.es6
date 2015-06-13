import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const WatchActions = {
  notifyError(msg) {
    ShredsDispatcher.dispatch({
      type: action.FAIL_NOTIFY,
      data: { type: null },
      failMsg: msg
    });
  }
};

export default WatchActions;
