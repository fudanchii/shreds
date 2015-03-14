(function (Shreds) { 'use strict';
  Shreds.registerComponent('backyard', {
    init: function () { },
    events: {
      'backyard:subscriptions': function (ev, data) {
        Shreds.feeds.render('backyard/subscriptions');
      }
    }
  });
})(window.Shreds);
