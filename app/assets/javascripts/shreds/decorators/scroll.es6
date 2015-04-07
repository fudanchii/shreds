import $ from 'jquery';
import Decorator from 'framework/decorator';

const $container = $('body,html');

Decorator.add('scrollUp', () => {
  const scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
  if (scrollTop > 0) {
    setTimeout(() => {
      $container.stop(true, true).animate({scrollTop: 0}, 850, 'easeOutCubic');
    }, 35);
  }
});
