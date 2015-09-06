// Setting max-width to 100% and width to 100% will make images stretch
// to the container size. Set default width to 100% but let smaller images
// to keep its original size by setting the width to `auto`
// the comparison value is set to arbitrary (hopefully sensible) ratio
// between feed container width against sidebar width.
// TODO: check this behavior on safari.

import Decorator from 'framework/decorator';
import $ from 'jquery';

function fixSize(el) {
  if (el.naturalWidth === 0) {
    $(el).one('load', () => { fixSize(el); });
    return;
  }
  if (el.naturalWidth < (60/100 * $(window).width())) {
    $(el).width('auto');
  } else {
    $(el).width('100%');
  }
}

Decorator.add('fixResponsiveImages', () => {
  $('.feed-content img').each((i, el) => {
    fixSize(el);
  });
});
