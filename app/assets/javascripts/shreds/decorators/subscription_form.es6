import $ from 'jquery';
import Decorator from 'framework/decorator';

$(document).on('click', (ev) => {
  if (collapsed && amOut) {
    Decorator.do('slideUpSubscriptionForm');
  }
});

let collapsed = false;

Decorator.add('slideDownSubscriptionForm', () => {
  $('#subscribeInput').slideDown();
  collapsed = true;
});

Decorator.add('slideUpSubscriptionForm', () => {
  $('#subscribeInput').slideUp();
  collapsed = false;
});
