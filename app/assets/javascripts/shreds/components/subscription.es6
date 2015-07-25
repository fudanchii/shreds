import Component from 'framework/component';
import Decorator from 'framework/decorator';

import NavigationActions from 'shreds/actions/navigation';
import SubscriptionStore from 'shreds/stores/subscription';
import SubscriptionActions from 'shreds/actions/subscription';

const SubscriptionComponent = Component.extend({
  el: '#subscribe_form',

  template: Component.template('subscription'),

  data() { return SubscriptionStore.get(); },

  oninit() {
    SubscriptionStore.addChangeListener((ev, payload) => {
      this.update();
    });

    this.on('subscribe', () => {
      if (!this.get('collapsed')) {
        SubscriptionActions.collapse();
      } else {
        SubscriptionActions.subscribe(this.find('#new_feed'));
        this.find('#feed_url').value = '';
        this.find('#category_name').value = '';
      }
      return false;
    });

    this.on('navigate', () => {
      NavigationActions.navigate('/', 0, 0);
    });

    this.on('import-opml', () => {
      Decorator.do('selectFileThenUpload');
    });

    this.observe('collapsed', (newValue, oldValue, keypath) => {
      newValue?
        Decorator.do('slideDownSubscriptionForm'):
        Decorator.do('slideUpSubscriptionForm');
    });

    this.observe('spinnerStarted', (newValue, oldValue, keypath) => {
      newValue?
        Decorator.do('startSubscribeSpinner'):
        Decorator.do('stopSubscribeSpinner');
    });

    this.observe('uploadSpinnerStarted', (newValue, oldValue, keypath) => {
      newValue?
        Decorator.do('startUploadSpinner'):
        Decorator.do('stopUploadSpinner');
    });
  }
});

export default SubscriptionComponent;
