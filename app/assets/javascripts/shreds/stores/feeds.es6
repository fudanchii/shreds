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
    const __this = this;
    ShredsAppStore.load({ toDisplay: 'feeds' });
    ShredsAppStore.emitChange({
      callable() {
        __this.refresh(payload.data);
        __this.emitChange({ rerender: true });
      }
    });
  }
});

export default FeedsStore;
