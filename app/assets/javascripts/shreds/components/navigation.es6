import Component from 'framework/component';
import NavigationStore from 'shreds/stores/navigation';
import NavigationActions from 'shreds/actions/navigation';

import NavigationHelpers from 'shreds/helpers/navigation';

const Navigation = Component.extend({
  el: '[template=navigation]',
  template: Component.template('navigation'),
  data: NavigationStore.getData(),

  oninit(options) {
    this._super(options);
    NavigationStore.addChangeListener((ev, data) => {
      this.update();
    });
    this.on('navigate', (ev, path, cid, fid) => {
      NavigationActions.navigate(path, cid, fid);
      this.find(`a[href="${path}"]`).click();
    });
    this.on('mark-as-read', (ev, cid, fid) => {
      NavigationActions.markAsRead(cid, fid);
      return false;
    });
  }
});

export default Navigation;
