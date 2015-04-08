import Component from 'framework/component';
import Decorator from 'framework/decorator';

import FeedsStore from 'shreds/stores/feeds';
import FeedsHelpers from 'shreds/helpers/feeds';

const Feeds = Component.extend({
  template: Component.template('feeds'),

  data() { return FeedsStore.getData(); },

  partials: {
    newsitems: Component.template('feeds/_newsitems')
  },

  oninit() {
    FeedsStore.addChangeListener((ev, payload) => {
      this.parent.fadeOut().then(() => {
        this.assign(payload.data);
        this.parent.fadeIn();
        Decorator.do('scrollUp');
        Decorator.do('setTitle', payload.data.title);
      });
    });
  }
});

export default Feeds;
