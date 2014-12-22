(function (Shreds, Router) { 'use strict';
  Shreds.registerComponent('routes', {
    init: function () {
      var r = new Router({
        debug: false,
        anchor: Shreds.$,
        on_dispatch: 'shreds:route:dispatched'
      });
      r.define('/',                    'feeds:render:index');
      r.define('/backyard/settings',   'backyard:settings');
      r.define('/categories',          'categories:render:index');
      r.define('/page/:page',          'feeds:render:page');
      r.define('/:feed_id',            'feed:render:show');
      r.define('/:feed_id/page/:page', 'feed:render:page');
      r.define('/:feed_id/:id',        'newsitem:render:show');
      if (!$('meta[name=pre-rendered]').attr('value')) {
        r.dispatch();
      } else {
        Shreds.$.trigger('shreds:route:dispatched');
      }
      Shreds.$.trigger('shreds:feed:postrender');
    }
  });
})(window.Shreds, window.Router);
