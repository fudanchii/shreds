import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const NavigationActions = {
  reloadNavigation(data) {
    ShredsDispatcher.dispatch({
      type: action.RELOAD_NAVIGATION,
      data
    });
  }
};

export default NavigationActions;
