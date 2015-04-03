import Component from 'framework/component';

import FeedsStore from 'shreds/stores/feeds';
import ScrollActions from 'shreds/actions/scroll';

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
        Component.assign(this, data.data);
        this.parent.fadeIn();
        ScrollActions.scrollUp();
      });
    });
  }
});

export default Feeds;
