import $ from 'jquery';
import Decorator from 'framework/decorator';

import SubscriptionActions from 'shreds/actions/subscription';

const $subscribeForm = $('#subscribe_form');

let collapsed = false,
    amOut = true;

Decorator.add('slideDownSubscriptionForm', () => {
  $('#subscribeInput').slideDown();
  $('#feed_url').focus();
  collapsed = true;
});

Decorator.add('slideUpSubscriptionForm', () => {
  $('#subscribeInput').slideUp();
  collapsed = false;
});

$(document).on('mousedown', (ev) => {
  if (collapsed && amOut) {
    SubscriptionActions.uncollapse();
  }
});

$(document).on('mouseover', (ev) => {
  amOut = false;
  if (collapsed && ($subscribeForm.find(ev.target).length === 0)) {
    amOut = true;
  }
});
