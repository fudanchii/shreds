import ShredsDispatcher from 'shreds/dispatcher';
import { event } from 'shreds/constants';

const WebAPIServiceActions = {
  routeNavigated(route, data) {
    ShredsDispatcher.dispatch({
      type: event.ROUTE_NAVIGATED,
      data,
      route
    });
  },

  feedMarkedAsRead(data) {
    ShredsDispatcher.dispatch({
      type: event.FEED_MARKED_AS_READ,
      data
    });
  }
};

export default WebAPIServiceActions;
