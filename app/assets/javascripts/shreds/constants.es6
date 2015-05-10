import * as defconst from 'framework/helpers/constants';

export const action = Object.assign({}, defconst.action, {
  SCROLL_UP:                  'shreds:action:scrollUp',
  MARK_FEED_AS_READ:          'shreds:action:markFeedAsRead',
  MARK_ITEM_AS_READ:          'shreds:action:markItemAsRead',
  NAVIGATE:                   'shreds:action:navigate',
  RELOAD_NAVIGATION:          'shreds:action:reloadNavigation',
  FAIL_NOTIFY:                'shreds:action:failNotify',
  COLLAPSE_SUBSCRIPTION_FORM: 'shreds:action:collapseSubscriptionForm',
  SUBSCRIBE_TO_FEED:          'shreds:action:subscribeToFeed'
});

export const event = Object.assign({}, defconst.event, {
  FEED_MARKED_AS_READ:     'shreds:event:feedMarkedAsRead',
  ITEM_MARKED_AS_READ:     'shreds:event:itemMarkedAsRead',
  FEED_SUBSCRIBED:         'shreds:event:feedSubscribed'
});
