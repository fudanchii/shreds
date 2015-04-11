import Component from 'framework/component';
import Decorator from 'framework/decorator';

import SubscriptionStore from 'shreds/stores/subscription';
import SubscriptionActions from 'shreds/actions/subscription';

const SubscriptionComponent = Component.extend({
  el: '#subscribe_form',

  template: Component.template('subscription'),

  data() { return SubscriptionStore.getData(); },

  oninit() {
    SubscriptionStore.addChangeListener((ev, payload) => {
      this.update();
    });

    this.on('subscribe', () => {
      if (!this.get('collapsed')) {
        SubscriptionActions.collapse();
        return false;
      }
      SubscriptionActions.subscribe(this.find('#new_feed'));
      return false;
    });

    this.observe('collapsed', (newValue, oldValue, keypath) => {
      if (newValue) {
        Decorator.do('slideDownSubscriptionForm');
        return;
      }
      Decorator.do('slideUpSubscriptionForm');
    });
  }
});

export default SubscriptionComponent;
