import Service from 'framework/service';
import F from 'framework/helpers/fetch';
import { join } from 'framework/helpers/path';
import I18n from 'I18n';

import ShredsDispatcher from 'shreds/dispatcher';
import Events from 'shreds/actions/web_api_service';
import Notification from 'shreds/actions/notification';
import { action, event } from 'shreds/constants';


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
        navigateIndex: F.get('/i/feeds.json'),
        navigate: F.get('/i/feeds/:fid.json'),
        markFeedAsRead: F.patch('/i/feeds/:fid/mark_as_read.json'),
        markItemAsRead: F.patch('/i/feeds/:fid/:eid/toggle_read.json'),
        subscribe: F.post('/i/subscriptions.json'),
        watchEvents: F.get('/i/watch.json')
      },
      headers: {
        'X-CSRF-Token': tTag.getAttribute('content')
      }
    });
  },

  navigate(payload) {
    const path = payload.path === '/' ? 'navigateIndex' : 'navigate';
    this.fetch.json(path,{ args: { fid: payload.path } })
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
