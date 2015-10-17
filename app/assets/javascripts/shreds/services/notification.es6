import Component from 'framework/component';
import Service from 'framework/service';

import ShredsDispatcher from 'shreds/dispatcher';
import { action, event } from 'shreds/constants';

const NotificationService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
        [action.FAIL_NOTIFY,        this.failNotify],
        [action.INFO_NOTIFY,        this.okNotify],
        [event.FEED_MARKED_AS_READ, this.okNotify],
        [event.ITEM_MARKED_AS_READ, this.okNotify],
    ]);
  },

  notify: {
    info(message) {
      new Notification({ data: { type: 'blue', text: message } });
    },
    error(message) {
      new Notification({ data: { type: 'red', text: message } });
    }
  },

  failNotify(payload) {
    this.notify.error(payload.failMsg);
  },

  okNotify(payload) {
    this.notify.info(payload.data.info);
  }
});

const Notification = Component.extend({
  append: true,

  el: '[data-template=notification]',

  template: Component.template('notification'),

  data: {
    type: '',
    text: ''
  },

  oninit() {
    this.on('complete', (ev) => {
      setTimeout(() => {
        this.teardown();
      }, 4500);
    });
  }
});

export default NotificationService;
