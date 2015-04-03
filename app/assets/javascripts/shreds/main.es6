import Application from 'framework/application';
import Component from 'framework/component';

import RoutesService from 'shreds/services/routes';
import WebAPIService from 'shreds/services/web_api';
import NProgressService from 'shreds/services/nprogress';
import ScrollService from 'shreds/services/scroll';

import ShredsAppStore from 'shreds/stores/shreds_app';

const ShredsAppView = Component.extend({
  el: '[template=main-view]',
  template() { return Component.template('main_view') },
  data: ShredsAppStore.getData(),
  oninit() {
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
  prerender: ['navigation']
});

export default Shreds;
