import ShredsDispatcher from 'shreds/dispatcher';
import { event } from 'shreds/constants';

const WebAPIServiceActions = {
  routeNavigated(data) {
    ShredsDispatcher.dispatch({
      type: event.ROUTE_NAVIGATED,
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
