import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const NavigationStore = new Store({
  respondToRoutes: ['feeds/showNewsitem'],
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED, this.routeHandler(this.navigated)]
    ]);
  },

  navigated(payload) {
    ShredsAppStore.viewChange('newsitem', () => {
      this.refresh(payload.data);
      this.emitChange();
    });
  }
});

export default NavigationStore;
