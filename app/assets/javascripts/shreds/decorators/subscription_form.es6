import $ from 'jquery';
import Decorator from 'framework/decorator';

import SubscriptionStore from 'shreds/stores/subscription';

const $subscribeForm = $('#subscribe_form');

let collapsed = false,
    amOut = true;

Decorator.add('slideDownSubscriptionForm', () => {
  $('#subscribeInput').slideDown();
  collapsed = true;
});

Decorator.add('slideUpSubscriptionForm', () => {
  $('#subscribeInput').slideUp();
  collapsed = false;
});

$(document).on('mousedown', (ev) => {
  if (collapsed && amOut) {
    SubscriptionStore.set('collapsed', false);
    SubscriptionStore.emitChange();
  }
});

$(document).on('mouseover', (ev) => {
  amOut = false;
  if ($subscribeForm.find(ev.target).length === 0 ) {
    amOut = true;
  }
});
