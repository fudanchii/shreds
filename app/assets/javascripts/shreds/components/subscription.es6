import Component from 'framework/component';
import Decorator from 'framework/decorator';

import SubscriptionStore from 'shreds/stores/subscription';
import SubscriptionAction from 'shreds/actions/subscription';

const SubscriptionComponent = Component.extend({
  el: '#subscription_form',

  template: Component.template('subscription'),

  data() { return SubscriptionStore.getData(); },

  oninit() {
    SubscriptionStore.addChangeListener((ev, payload) => {
      this.update();
    });
    this.on('subscribe', () => {
      if (!this.get('collapsed')) {
        Decorator.do('slideDownSubscriptionForm');
        this.set('collapsed', true);
        return false;
      }
      SubscriptionAction.subscribe({
        url: this.get('feedURL'),
        category: this.get('categoryName')
      });
      Decorator.do('slideUpSubscriptionForm');
      this.set('collapsed', false);
      return false;
    });
  }
});

export default SubscriptionComponent;
