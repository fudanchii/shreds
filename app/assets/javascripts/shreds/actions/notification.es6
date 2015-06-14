import ShredsDispatcher from 'shreds/dispatcher';

import { action } from 'shreds/constants';

const NotificationActions = {
 error(msg) {
   ShredsDispatcher.dispatch({
      type: action.FAIL_NOTIFY,
      data: { type: null },
      failMsg: msg
    });
 },

 info(msg) {
   ShredsDispatcher.dispatch({
     type: action.INFO_NOTIFY,
     data: { info: msg }
   });
 }
};

export default NotificationActions;
