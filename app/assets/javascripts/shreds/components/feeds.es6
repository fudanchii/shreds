import Component from 'framework/component';
import Decorator from 'framework/decorator';

import FeedsStore from 'shreds/stores/feeds';
import FeedsHelpers from 'shreds/helpers/feeds';
import FeedActions from 'shreds/actions/feed';
import NavigationActions from 'shreds/actions/navigation';

const FeedsComponent = Component.extend({
  template: Component.template('feeds'),

  data() { return FeedsStore.get(); },

  partials: {
    newsitems: Component.template('feeds/_newsitems')
  },

  oninit() {
    FeedsStore.addChangeListener((ev, payload) => {
      this.assign(payload.data);
      Decorator.do('setTitle', this.get('title'));
    });

    this.on('mark-as-read', (ev, fid, nid) => {
      FeedActions.markAsRead(fid, nid);
      return false;
    });

    this.on('navigate', (ev, path, cid, fid) => {
      NavigationActions.navigate(path, cid, fid);
    });

    Decorator.do('setTitle', this.get('title'));
  }
});

export default FeedsComponent;
