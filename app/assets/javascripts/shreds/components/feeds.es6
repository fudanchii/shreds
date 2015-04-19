import Component from 'framework/component';
import Decorator from 'framework/decorator';

import FeedsStore from 'shreds/stores/feeds';
import FeedsHelpers from 'shreds/helpers/feeds';

const FeedsComponent = Component.extend({
  template: Component.template('feeds'),

  data() { return FeedsStore.getData(); },

  partials: {
    newsitems: Component.template('feeds/_newsitems')
  },

  oninit() {
    FeedsStore.addChangeListener((ev, payload) => {
      this.assign(payload.data);
      Decorator.do('setTitle', this.get('title'));
    });
    Decorator.do('setTitle', this.get('title'));
  }
});

export default FeedsComponent;
