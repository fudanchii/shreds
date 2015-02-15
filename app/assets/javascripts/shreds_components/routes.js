(function (Shreds, Router) { 'use strict';
  Shreds.registerComponent('routes', {
    init: function () {
      var r = new Router({
        anchor: Shreds.$,
        on_dispatch: 'shreds:route:dispatched'
      });
      r.map('/',                       'feeds:render:index');
      r.map('/backyard/subscriptions', 'backyard:subscriptions');
      r.map('/categories',             'categories:render:index');
      r.map('/page/:page',             'feeds:render:page');
      r.map('/:feed_id',               'feed:render:show');
      r.map('/:feed_id/page/:page',    'feed:render:page');
      r.map('/:feed_id/:id',           'newsitem:render:show');
      if (!$('meta[name=pre-rendered]').attr('value')) {
        r.dispatch();
      } else {
        Shreds.$.trigger('shreds:route:dispatched');
      }
      Shreds.$.trigger('shreds:feed:postrender');
    }
  });
})(window.Shreds, require('router').Router);
