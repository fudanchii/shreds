import Store from 'framework/store';

import ShredsDispatcher from 'shreds/dispatcher';
import ShredsAppStore from 'shreds/stores/shreds_app';
import { event } from 'shreds/constants';

const FeedsStore = new Store({
  respondToRoutes: ['feeds', 'feeds/page'],
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.ROUTE_NAVIGATED, this.routeHandler(this.navigated)]
    ]);
  },

  navigated(payload) {
    ShredsAppStore.viewChange('feeds', () => {
      this.refresh(payload.data);
      this.emitChange('feeds');
    });
  }
});

export default FeedsStore;