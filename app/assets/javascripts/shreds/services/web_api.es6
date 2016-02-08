import Service from 'framework/service';
import req from 'framework/helpers/ajax';
import { join } from 'framework/helpers/path';
import I18n from 'I18n';

import ShredsDispatcher from 'shreds/dispatcher';
import WebAPIServiceActions from 'shreds/actions/web_api_service';
import { action, event } from 'shreds/constants';

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
          const tTag = document.querySelector('meta[name=csrf-token]');
          if (tTag) {
            xhr.setRequestHeader('X-CSRF-Token', tTag.getAttribute('content'));
          }
        }
      ]
    });
  },

  navigate(payload) {
    const prefix = payload.name.split('/')[0];
    if (prefix === 'feeds') {
      payload.path = join('/feeds', payload.path);
    }

    req
      .get(payload.path + '.json', {
        failMsg: I18n.t('js.fail.navigate'),
        failPayload: payload
      })
      .done((data) => {
        WebAPIServiceActions.routeNavigated(payload, data);
      });
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
      .post('/feeds.json', {
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
    return req.get('/watch.json', {
      data: { watchList: list.join() }
    });
  }
});

export default WebAPIService;
