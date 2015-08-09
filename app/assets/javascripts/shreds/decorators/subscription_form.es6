import $ from 'jquery';
import Decorator from 'framework/decorator';

import SubscriptionActions from 'shreds/actions/subscription';

const $subscribeForm = $('#subscribe-form'),
      $document = $(document);

let collapsed = false,
    amOut = true;

Decorator.add('slideDownSubscriptionForm', () => {
  $('#subscribeInput').slideDown();
  $('#feed_url').focus();
  collapsed = true;
  $document.on('mouseover', _.throttle(ev => {
    amOut = false;
    if (collapsed && ($subscribeForm.find(ev.target).length === 0)) {
      amOut = true;
    }
  }, 250));

  $document.on('mousedown', ev => {
    if (collapsed && amOut) {
      SubscriptionActions.uncollapse();
    }
  });
});

Decorator.add('slideUpSubscriptionForm', () => {
  $('#subscribeInput').slideUp();
  collapsed = false;
  $document.off('mouseover');
  $document.off('mousedown');
});



