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
      this.parent.fadeOut().then(() => {
        this.assign(payload.data);
        this.parent.fadeIn();
        Decorator.do('scrollUp');
        Decorator.do('setTitle', payload.data.title);
      });
    });
  }
});

export default FeedComponent;
