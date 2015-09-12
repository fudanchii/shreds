import Application from 'framework/application';
import Component from 'framework/component';
import Decorator from 'framework/decorator';

import ShredsAppStore from 'shreds/stores/shreds_app';

const ShredsAppView = Component.extend({
  el: '[data-template=main-view]',

  template() { return Component.template('main_view'); },

  data() { return ShredsAppStore.get(); },

  oninit() {
    ShredsAppStore.addChangeListener((ev, payload) => {
      if (payload.meta && _.isFunction(payload.meta.callable)) {
        payload.meta.callable();
      }
      this.assign(payload.data);
      Decorator.do('fixResponsiveImages');
      Decorator.do('scrollUp');
    });

    this.on('complete', () => {
      Decorator.do('fixResponsiveImages');
    });

    Decorator.do('backtoTop');
  }
});

const Shreds = new Application(ShredsAppView, {
  name: "shreds",
  prerender: ['navigation', 'subscription']
});

export default Shreds;
