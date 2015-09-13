import Component from 'framework/component';
import NavigationStore from 'shreds/stores/navigation';
import NavigationActions from 'shreds/actions/navigation';
import FeedsActions from 'shreds/actions/feeds';

import NavigationHelpers from 'shreds/helpers/navigation';

const Navigation = Component.extend({
  el: '[data-template=navigation]',

  template: Component.template('navigation'),

  data() { return NavigationStore.get(); },

  oninit(options) {
    NavigationStore.addChangeListener((ev, data) => {
      this.update();
    });

    this.on('navigate', (ev, path, cid, fid) => {
      this.find(`a[href="${path}"]`).click();
    });

    this.on('mark-as-read', (ev, cid, fid) => {
      FeedsActions.markAsRead(cid, fid);
      return false;
    });
  }
});

export default Navigation;
