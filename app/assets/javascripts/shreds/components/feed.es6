import Component from 'framework/component';

import FeedStore from 'shreds/stores/feed';
import ShredsDispatcher from 'shreds/dispatcher';

const FeedComponent = Component.extend({
  template: Component.template('feed'),

  data() { return FeedStore.getData(); },

  oninit() {
    FeedStore.addChangeListener((ev, payload) => {
      this.update();
    });
  }
});

export default FeedComponent;
