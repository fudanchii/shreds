import Service from 'framework/service';
import req from 'framework/helpers/ajax';
import Fetch from 'framework/helpers/fetch';
import { join } from 'framework/helpers/path';
import I18n from 'I18n';

import ShredsDispatcher from 'shreds/dispatcher';
import WebAPIServiceActions from 'shreds/actions/web_api_service';
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
    req.init({
      baseURI: '/i',
      dispatcher: ShredsDispatcher,
      failAction: action.FAIL_NOTIFY,
      prefilters: [
        function (opts, oriOpts, xhr) {
          if (tTag) {
            xhr.setRequestHeader('X-CSRF-Token', tTag.getAttribute('content'));
          }
        }
      ]
    });
    this.fetcher = new Fetch({
      endpoints: {
        navigateIndex: '/i/feeds.json',
        navigate: '/i/feeds/:fid.json',
        markFeedAsRead: '/i/feeds/:fid/mark_as_read.json',
        markItemAsRead: '/i/feeds/:fid/:eid/toggle_read.json',
        subscribe: '/i/subscriptions.json',
        watchEvents: '/i/watch.json'
      },
      headers: {
        'X-CSRF-Token': tTag.getAttribute('content')
      },
      errorHandler: {
        dispatcher: ShredsDispatcher,
        failAction: action.FAIL_NOTIFY
      }
    });
  },

  navigate(payload) {
    // FIXME: Consider using `gon` to load rails var
    const path = payload.path === '/' ? 'navigateIndex' : 'navigate';
    this.fetcher.getJSON(path, { params: { fid: payload.path } })
      .then((data) => { WebAPIServiceActions.routeNavigated(payload, data) });
  },

  markFeedAsRead(payload) {
    req
      .patch(join('/feeds', payload.fid, '/mark_as_read.json'), {
        failMsg: I18n.t('js.fail.mark_feed_as_read'),
        failPayload: payload
      })
    .done((data) => {
      WebAPIServiceActions.feedMarkedAsRead(data);
    });
  },

  markItemAsRead(payload) {
    req
      .patch(join('/feeds', payload.fid, payload.nid, '/toggle_read.json'), {
        failMsg: I18n.t('js.fail.toggle_read'),
        failPayload: payload
      })
    .done((data) => {
      WebAPIServiceActions.itemMarkedAsRead(data);
    });
  },

  subscribe(payload) {
    req
      .post('/subscriptions.json', {
        data: new FormData(payload.form),
        processData: false,
        contentType: false,
        failMsg: I18n.t('js.fail.subscribe'),
        failPayload: payload
      })
    .done((data) => {
      WebAPIServiceActions.feedSubscribed(data);
    });
  },

  watchEvents(list) {
    return this.fetcher.getJSON('watchEvents', {
      queries: { watchList: list.join() }
    });
  }
});

export default WebAPIService;
