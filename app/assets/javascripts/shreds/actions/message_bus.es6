import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const MessageBusActions = {
  keepAlive() {
    ShredsDispatcher.dispatch({ type: action.KEEPALIVE });
  }
};

export default MessageBusActions;
