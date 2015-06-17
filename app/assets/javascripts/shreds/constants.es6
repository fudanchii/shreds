import * as defconst from 'framework/helpers/constants';

export const action = defconst.defActions(
  'SCROLL_UP',
  'MARK_FEED_AS_READ',
  'MARK_ITEM_AS_READ',
  'NAVIGATE',
  'RELOAD_NAVIGATION',
  'FAIL_NOTIFY',
  'INFO_NOTIFY',
  'COLLAPSE_SUBSCRIPTION_FORM',
  'UNCOLLAPSE_SUBSCRIPTION_FORM',
  'SUBSCRIBE_TO_FEED',
  'START_UPLOAD_SPINNER',
  'STOP_SUBSCRIBE_SPINNER',
  'STOP_UPLOAD_SPINNER');

export const event = defconst.defEvents(
  'FEED_MARKED_AS_READ',
  'ITEM_MARKED_AS_READ',
  'FEED_SUBSCRIBED',
  'OPML_UPLOADED');
