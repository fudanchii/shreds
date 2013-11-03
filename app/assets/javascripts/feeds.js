(function (Shreds) { 'use strict';
  var name = 'feeds';
  var container = $('.span-fixed-sidebar');

  Shreds.components.push(name);
  Shreds[name] = {
    init: function () { },
    render: function (context, url) {
      container.attr('data-template', context);
      Shreds.ajax.get(url).done(function (data) {
        Shreds.loadModel(context, data);
        Shreds.syncView(context);
      });
    },
    events: {
      'shreds:feeds:render:index': function (ev, data) {
        Shreds.feeds.render('feeds/index', '/i/feeds.json');
      },
      'shreds:feed:render:show': function (ev, data) {
        Shreds.feeds.render('feeds/show', '/i/feeds/' + data.id + '.json');
      }
    }
  };
})(window.Shreds);
