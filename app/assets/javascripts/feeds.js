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
        document.title = '[shreds] - ' + (data.title || 'Feeds');
      });
    },
    events: {
      'shreds:feeds:render:index': function (ev, data) {
        Shreds.feeds.render('feeds/index', '/i/feeds.json');
      },
      'shreds:feed:render:show': function (ev, data) {
        Shreds.feeds.render('feeds/show', '/i/feeds/' + data.id + '.json');
      },
      'shreds:newsitem:render:show': function (ev, data) {
        Shreds.feeds.render('newsitem', '/i/feeds/' + data.feed_id + '/' + data.id + '.json');
      },
    }
  };
})(window.Shreds);
