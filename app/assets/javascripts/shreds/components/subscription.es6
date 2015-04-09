import Component from 'framework/component';
import Decorator from 'framework/decorator';

const SubscriptionComponent = Component.extend({
  template: Component.template('subscription'),

  data() { return SubscriptionStore.getData(); },

  oninit() {
    on('subscribe', () => {
      if (!this.get('collapsed')) {
        Decorator.do('slideDownSubscriptionForm');
        return false;
      }
      SubscriptionAction.subscribe({
        url: this.get('feedURL'),
        category: this.get('categoryName')
      });
      Decorator.do('slideUpSubscriptionForm');
      return false;
    });
  }
});

export default SubscriptionComponent;
