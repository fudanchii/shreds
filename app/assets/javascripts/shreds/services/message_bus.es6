import MessageBus from 'message-bus'
import Service from 'framework/service'

import ShredsDispatcher from 'shreds/dispatcher';
import WebAPIService from 'shreds/services/web_api';
import NavigationActions from 'shreds/actions/navigation';
import NotificationActions from 'shreds/actions/notification';
import SubscriptionActions from 'shreds/actions/subscription';
import { event } from 'shreds/constants';
import I18n from 'I18n';

const MessageBusService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.FEED_SUBSCRIBED, this.eventHandler],
      [event.OPML_UPLOADED,   this.eventHandler]
    ]);
    MessageBus.subscribe('/updates', this.updateHandler);
  },

  updateHandler(msg) {
    if (msg.error) {
      NotificationActions.error(msg.error);
      return;
    }
    NavigationActions.reloadNavigation(msg.data);
    NotificationActions.info(msg.info);
  },

  eventHandler(payload) {
    var cb = (msg) => {
      console.log(msg);
      this.updateHandler(msg);
      SubscriptionActions.stopSubscribeSpinner();
      MessageBus.unsubscribe(`/${payload.data.watch}`, cb);
    };
    MessageBus.subscribe(`/${payload.data.watch}`, cb);
  },

});
