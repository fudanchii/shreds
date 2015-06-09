import Component from 'framework/component';
import Decorator from 'framework/decorator';

import FeedStore from 'shreds/stores/feed';
import FeedActions from 'shreds/actions/feed';
import NavigationActions from 'shreds/actions/navigation';

const FeedComponent = Component.extend({
  template: Component.template('feed'),

  data() { return FeedStore.getData(); },

  partials: {
    newsitems: Component.template('feeds/_newsitems')
  },

  oninit() {
    FeedStore.addChangeListener((ev, payload) => {
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

export default FeedComponent;
