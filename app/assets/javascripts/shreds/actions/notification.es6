import ShredsDispatcher from 'shreds/dispatcher';

import { action } from 'shreds/constants';

const NotificationActions = {
 error(msg, data = { type: null }) {
   ShredsDispatcher.dispatch({
      type: action.FAIL_NOTIFY,
      failMsg: msg,
      data
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
