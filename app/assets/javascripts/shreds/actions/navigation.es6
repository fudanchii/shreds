import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const NavigationActions = {
  navigate(path, cid, fid) {
    ShredsDispatcher.dispatch({
      type: action.NAVIGATE,
      cid, fid, path
    });
  },

  reloadNavigation(data) {
    ShredsDispatcher.dispatch({
      type: action.RELOAD_NAVIGATION,
      data
    });
  }
};

export default NavigationActions;
