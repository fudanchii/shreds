(function (Shreds, Lennon) {
  var name = 'routes';
  Shreds.components.push(name)
  Shreds[name] = {
    init: function () {
      var r = new Lennon({ publishEvent: Shreds.$.trigger.bind(Shreds.$) });
      r.define('/',               'shreds:feeds:render:index');
      r.define('/page/:page',     'shreds:feeds:render:page');
      r.define('/:id',            'shreds:feed:render:show');
      r.define('/:id/page/:page', 'shreds:feed:render:page');
      r.define('/:feed_id/:id',   'shreds:newsitem:render:show');
    }
  };
})(window.Shreds, window.Lennon);
