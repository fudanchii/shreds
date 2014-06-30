(function (Shreds, Router) { 'use strict';
  var name = 'routes';
  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {
      var r = new Router({
        debug: false,
        anchor: Shreds.$,
        on_dispatch: 'route:dispatched'
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
      }
    }
  };
})(window.Shreds, window.Router);
