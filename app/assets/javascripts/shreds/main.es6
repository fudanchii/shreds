import Application from 'framework/application';
import Component from 'framework/component';
import Decorator from 'framework/decorator';

import RoutesService from 'shreds/services/routes';
import WebAPIService from 'shreds/services/web_api';
import NProgressService from 'shreds/services/nprogress';

import _Scroll from 'shreds/decorators/scroll';
import _Title from 'shreds/decorators/title';
import _SubscriptionForm from 'shreds/decorators/subscription_form';

import ShredsAppStore from 'shreds/stores/shreds_app';

const ShredsAppView = Component.extend({
  el: '[template=main-view]',

  template() { return Component.template('main_view'); },

  data() { return ShredsAppStore.getData(); },

  oninit() {
    ShredsAppStore.addChangeListener((ev, payload) => {
      this.fadeOut().then(() => {
        this.assign(payload.data);
        this.fadeIn().then(() => {
          Decorator.do('scrollUp');
        });
      });
    });

    this.on('render', () => {
      setTimeout(() => { this.set('inflag', 'in'); }, 50);
    });

    this.on('unrender', () => {
      setTimeout(() => { this.set('inflag', ''); }, 50);
    });
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
  debug: true,
  prerender: ['navigation', 'subscription']
});

export default Shreds;
