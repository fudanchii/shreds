import Component from 'framework/component';

import FeedsStore from 'shreds/stores/feeds';
import ScrollActions from 'shreds/actions/scroll';

import FeedsHelpers from 'shreds/helpers/feeds';

const Feeds = Component.extend({
  template: Component.template('feeds'),
  data: FeedsStore.getData(),
  partials: {
    newsitems: Component.template('feeds/_newsitems')
  },

  oninit() {
    FeedsStore.addChangeListener((ev, data) => {
      this.data = data.data;
      this.parent.fadeOut().then(() => {
        this.update();
        this.parent.fadeIn();
      });
    });
  }
});

export default Feeds;
