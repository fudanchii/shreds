import Service from 'framework/service';

import ShredsDispatcher from 'shreds/dispatcher';
import WebAPIService from 'shreds/services/web_api';
import NavigationActions from 'shreds/actions/navigation';
import NotificationActions from 'shreds/actions/notification';
import SubscriptionActions from 'shreds/actions/subscription';
import { event } from 'shreds/constants';

const WatchService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
      [event.FEED_SUBSCRIBED, this.feedSubscribed],
      [event.OPML_UPLOADED,   this.opmlUploaded]
    ]);

    this.callbacks = {};
    this.list = [];
    setInterval(this.updateFeed, 600000);
  },

  doWatch(key, fn) {
    if (key) {
      this.list.push(key);
      if (kind(fn) === 'Function') { this.callbacks[key] = fn; }
    }
    if (this.list.length === 0) { return; }
    WebAPIService.watchEvents(this.list)
      .fail(() => { setTimeout(this.doWatch, 2000); })
      .done((data) => {
        data.forEach((k, v) => {
          if (kind(this.callbacks[k]) === 'Function') {
            this.callbacks[k](v);
            delete this.callbacks[k];
          }
        });
        this.list = this.list.filter(k => !data[k]);
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
    });
  }
});
