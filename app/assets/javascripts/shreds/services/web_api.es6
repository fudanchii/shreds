import Service from 'framework/service';
import F from 'framework/helpers/fetch';
import { join } from 'framework/helpers/path';
import { root_path } from 'shreds';
import I18n from 'I18n';

import ShredsDispatcher from 'shreds/dispatcher';
import Events from 'shreds/actions/web_api_service';
import Notification from 'shreds/actions/notification';
import { action, event } from 'shreds/constants';

function r(path) { return join(root_path, path); }

const tTag = document.querySelector('meta[name=csrf-token]');
const WebAPIService = new Service({
  oninit() {
    this.regDispatcher(ShredsDispatcher, [
        [action.NAVIGATE_TO_ROUTE, this.navigate],
        [action.MARK_FEED_AS_READ, this.markFeedAsRead],
        [action.MARK_ITEM_AS_READ, this.markItemAsRead],
        [action.KEEPALIVE,         this.keepAlive],
        [action.SUBSCRIBE_TO_FEED, this.subscribe]
    ]);
    this.fetch = new F({
      endpoints: {
        'feeds': F.get(r('/i/feeds.json')),
        'feeds/show': F.get(r('/i/feeds/:feed_id.json')),
        'feeds/show/newsitem': F.get(r('/i/feeds/:feed_id/:id.json')),
        'feeds/page': F.get(r('/i/feeds/page/:page.json')),
        'feeds/show/page': F.get(r('/i/feeds/:feed_id/page/:page.json')),
        keepAlive: F.get('/i/ping.json'),
        markFeedAsRead: F.patch(r('/i/subscriptions/:sid/mark_as_read.json')),
        markItemAsRead: F.patch(r('/i/feeds/:fid/:nid/toggle_read.json')),
        subscribe: F.post(r('/i/subscriptions.json')),
        watchEvents: F.get(r('/i/watch.json'))
      },
      headers: {
        'X-CSRF-Token': tTag.getAttribute('content')
      }
    });
  },

  navigate(payload) {
    this.fetch.json(payload.name, { args: payload.data })
      .then(data => { Events.routeNavigated(payload, data) })
      .catch(ex => Notification.error(ex, payload));
  },

  markFeedAsRead(payload) {
    this.fetch.json('markFeedAsRead', { args: payload })
      .then(data => { Events.feedMarkedAsRead(Object.assign(payload, data)) })
      .catch(ex => Notification.error(ex, payload));
  },

  markItemAsRead(payload) {
    this.fetch.cmd('markItemAsRead', { args: payload })
      .then(() => { Events.itemMarkedAsRead(payload) })
      .catch(ex => Notification.error(ex, payload));
  },

  keepAlive() {
    this.fetch.cmd('keepAlive', {})
      .catch(ex => Notification.error(ex));
  },

  subscribe(payload) {
    this.fetch.json('subscribe', {
      inits: { body: new FormData(payload.form) }
    })
      .then(data => Events.feedSubscribed(data))
      .catch(ex => Notification.error(ex, payload));
  }
});

export default WebAPIService;
