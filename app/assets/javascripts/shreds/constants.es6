import * as defconst from 'framework/helpers/constants';

export const action = Object.assign({}, defconst.action, {
  MARK_FEED_AS_READ: 'shreds:action:markFeedAsRead',
  NAVIGATE:          'shreds:action:navigate',
  FAIL_NOTIFY:       'shreds:action:failNotify'
});

export const event = Object.assign({}, defconst.event, {
  FEED_MARKED_AS_READ:     'shreds:event:feedMarkedAsRead'
});
