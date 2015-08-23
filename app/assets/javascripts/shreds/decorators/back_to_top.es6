import $ from 'jquery';
import Decorator from 'framework/decorator';

let applied = false;

Decorator.add('backtoTop', () => {
  if (applied) {
    return;
  }

  $.scrollUp({
    scrollSpeed: 850,
    easingType: 'easeOutCubic',
    scrollTitle: 'Back to top',
    scrollText: '<i class="chevron up icon"></i>',
  });

  applied = true;
});
