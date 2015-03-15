import ShredsDispatcher from 'shreds/dispatcher';
import { event } from 'shreds/constants';

const WebAPIServiceActions = {
  pageNavigated(data) {
    ShredsDispatcher.dispatch({
      type: event.NAVIGATION_STATE_PUSHED,
      data: data
    });
  },

  feedMarkedAsRead(data) {
    ShredsDispatcher.dispatch({
      type: event.FEED_MARKED_AS_READ,
      data: data
    });
  }
};

export default WebAPIServiceActions;
