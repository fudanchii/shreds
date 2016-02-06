import Service from 'framework/service';

import ShredsDispatcher from 'shreds/dispatcher';
import WebAPIService from 'shreds/services/web_api';
import NavigationActions from 'shreds/actions/navigation';
import NotificationActions from 'shreds/actions/notification';
import SubscriptionActions from 'shreds/actions/subscription';
import { event } from 'shreds/constants';
import I18n from 'I18n';

const WatchService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.FEED_SUBSCRIBED, this.feedSubscribed],
      [event.OPML_UPLOADED,   this.opmlUploaded]
    ]);

    this.callbacks = {};
    this.list = new Set();
    setInterval(this.updateFeed, 600000);
  },

  doWatch(key, fn) {
    if (key) {
      this.list.add(key);
      if (_.isFunction(fn)) { this.callbacks[key] = fn; }
    }
    if (this.list.size === 0) { return; }
    WebAPIService.watchEvents(Array.from(this.list))
      .fail(() => { setTimeout(this.doWatch, 2000); })
      .done((data) => {
        _.each(data, (v, k) => {
          if (_.isFunction(this.callbacks[k])) {
            this.callbacks[k](v);
            delete this.callbacks[k];
          }
        });
        this.list = new Set((Array.from(this.list)).filter(k => !data[k]));
      });
  },

  feedSubscribed(payload) {
    this.doWatch(payload.data.watch, (data) => {
      SubscriptionActions.stopSubscribeSpinner();
      if (data.error) {
        NotificationActions.error(data.error);
        return;
      }
      NavigationActions.reloadNavigation(data);
      NotificationActions.info(data.info);
    });
  },

  opmlUploaded(payload) {
    this.doWatch(payload.data.watch, (data) => {
      SubscriptionActions.stopUploadSpinner();
      if (data.error) {
        NotificationActions.error(data.error);
        return;
      }
      NavigationActions.reloadNavigation(data);
      NotificationActions.info(data.info);
    });
  },

  updateFeed() {
    this.doWatch('updateFeed', (data) => {
      NavigationActions.reloadNavigation(data);
      NotificationActions.info(I18n.t('js.feed.updated'));
    });
  }
});
