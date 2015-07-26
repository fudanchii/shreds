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
      this.fadeOut().then(() => {
        if (payload.meta && _.isFunction(payload.meta.callable)) {
          payload.meta.callable();
        }
        this.assign(payload.data);
        this.fadeIn();
        Decorator.do('scrollUp');
      });
    });

    this.on('complete', () => { this.fadeIn(); });

    Decorator.do('backtoTop');
  },

  fadeOut() {
    return new Promise((resolve, reject) => {
      this.set('inflag', '');
      setTimeout(() => { resolve(); }, 400);
    });
  },

  fadeIn() {
    return new Promise((resolve, reject) => {
      this.set('inflag', 'in');
      setTimeout(() => { resolve(); }, 400);
    });
  }
});

const Shreds = new Application(ShredsAppView, {
  name: "shreds",
  prerender: ['navigation', 'subscription']
});

export default Shreds;
