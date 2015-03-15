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
      [event.NAVIGATION_STATE_PUSHED, [], this.navigate],
      [action.MARK_FEED_AS_READ,      [], this.markFeedAsRead]
    ]);
    req.init({
      baseURI: '/i',
      dispatcher: ShredsDispatcher,
      failAction: action.FAIL_NOTIFY,
      prefilters: [function (opts, oriOpts, xhr) {
        const tokenTagExists = document.querySelector('meta[name=csrf-token]');
        if (tokenTagExists) {
          xhr.setRequestHeader('X-CSRF-Token',
                               tokenTagExists.getAttribute('content'));
        }
      }]
    });
  },

  navigate(payload) {
    req
      .get(join('/feeds', payload.path, '.json'), {
        failMsg: I18n.t('fail.navigate'),
        failPayload: payload
      })
      .done((data) => {
        WebAPIServiceActions.pageNavigated(data);
      });
  },

  markFeedAsRead(payload) {
    req
      .patch(join('/feeds', payload.fid, '/mark_as_read.json'), {
        failMsg: I18n.t('fail.mark_feed_as_read'),
        failPayload: payload
      })
      .done((data) => {
        WebAPIServiceActions.feedMarkedAsRead(data);
      });
  }
});

export default WebAPIService;
