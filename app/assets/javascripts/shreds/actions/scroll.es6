import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const ScrollActions = {
  scrollUp() {
    ShredsDispatcher.dispatch({
      type: action.SCROLL_UP
    });
  }
};

export default ScrollActions;
