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
    FeedsStore.addChangeListener((ev, data) => {
      this.parent.fadeOut().then(() => {
        this.assign(data.data);
        this.parent.fadeIn();
        Decorator.do('scrollUp');
      });
    });
  }
});

export default Feeds;
