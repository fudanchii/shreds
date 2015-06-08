import * as defconst from 'framework/helpers/constants';

export const action = defconst.defActions(
  'SCROLL_UP',
  'MARK_FEED_AS_READ',
  'MARK_ITEM_AS_READ',
  'NAVIGATE',
  'RELOAD_NAVIGATION',
  'FAIL_NOTIFY',
  'COLLAPSE_SUBSCRIPTION_FORM',
  'SUBSCRIBE_TO_FEED');

export const event = defconst.defEvents(
  'FEED_MARKED_AS_READ',
  'ITEM_MARKED_AS_READ',
  'FEED_SUBSCRIBED');
