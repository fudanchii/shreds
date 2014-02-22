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
      r.define('/',               'feeds:render:index');
      r.define('/page/:page',     'feeds:render:page');
      r.define('/:id',            'feed:render:show');
      r.define('/:id/page/:page', 'feed:render:page');
      r.define('/:feed_id/:id',   'newsitem:render:show');
      if (!$('meta[name=pre-rendered]').attr('value')) {
        r.dispatch();
      }
    }
  };
})(window.Shreds, window.Router);
