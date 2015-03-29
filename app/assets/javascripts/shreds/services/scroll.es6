import $ from 'jquery';

import Service from 'framework/service';

import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'shreds/constants';

const $container = $('body,html');

const ScrollService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [action.SCROLL_UP, this.scrollUp]
    ]);
  },

  scrollUp() {
    const scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
    if (scrollTop > 0) {
      setTimeout(() => {
        $container.stop(true, true).animate({scrollTop: 0}, 850, 'easeOutCubic');
      }, 35);
    }
  }
});
