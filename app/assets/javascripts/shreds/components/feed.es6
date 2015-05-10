import Component from 'framework/component';
import Decorator from 'framework/decorator';

import FeedStore from 'shreds/stores/feed';
import ShredsDispatcher from 'shreds/dispatcher';
import FeedActions from 'shreds/actions/feed';

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
    Decorator.do('setTitle', this.get('title'));
  }
});

export default FeedComponent;
