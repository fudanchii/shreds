import Component from 'framework/component';
import Decorator from 'framework/decorator';

import FeedStore from 'shreds/stores/feed';
import ShredsDispatcher from 'shreds/dispatcher';

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
    Decorator.do('setTitle', this.get('title'));
  }
});

export default FeedComponent;
