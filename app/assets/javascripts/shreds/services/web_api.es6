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
        [action.SUBSCRIBE_TO_FEED, this.subscribe]
    ]);
    this.fetch = new F({
      endpoints: {
        navigateIndex: F.get(r('/i/feeds.json')),
        navigateFeeds: F.get(r('/i/feeds/:fid.json')),
        navigateArticles: F.get(r('/i/feeds/:fid/:aid.json')),
        markFeedAsRead: F.patch(r('/i/feeds/:fid/mark_as_read.json')),
        markItemAsRead: F.patch(r('/i/feeds/:fid/:eid/toggle_read.json')),
        subscribe: F.post(r('/i/subscriptions.json')),
        watchEvents: F.get(r('/i/watch.json'))
      },
      headers: {
        'X-CSRF-Token': tTag.getAttribute('content')
      }
    });
  },

  navigate(payload) {
    const path = (payload.path === root_path) ?
      'navigateIndex' : ((payload.data && payload.data.id) ?
        'navigateArticles' : 'navigateFeeds'),
      fid = payload.data && payload.data.feed_id,
      aid = payload.data && payload.data.id;
    this.fetch.json(path,{ args: { fid: fid, aid: aid } })
      .then(data => { Events.routeNavigated(payload, data) })
      .catch(ex => Notification.error(ex, payload));
  },

  markFeedAsRead(payload) {
    this.fetch.cmd('markFeedAsRead', { args: { fid: payload.fid } })
      .then(() => { Events.feedMarkedAsRead(payload) })
      .catch(ex => Notification.error(ex, payload));
  },

  markItemAsRead(payload) {
    this.fetch.cmd('markItemAsRead', {
      args: { fid: payload.fid, eid: payload.nid }
    })
      .then(() => { Events.itemMarkedAsRead(payload) })
      .catch(ex => Notification.error(ex, payload));
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
