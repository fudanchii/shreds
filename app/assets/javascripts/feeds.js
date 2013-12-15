(function (Shreds) { 'use strict';
  var name = 'feeds';
  var feedView = $('.span-fixed-sidebar');
  var container = $('body,html');

  Shreds.components.push(name);
  Shreds[name] = {
    init: function () { },
    events: {
      'shreds:feeds:render:index': function (ev, data) {
        render('feeds/index', '/i/feeds.json');
      },
      'shreds:feeds:render:page': function (ev, data) {
        render('feeds/index', '/i/feeds/page/' + data.page + '.json');
      },
      'shreds:feed:render:show': function (ev, data) {
        render('feeds/show', '/i/feeds/' + data.id + '.json');
      },
      'shreds:feed:render:page': function (ev, data) {
        render('feeds/show', '/i/feeds/' + data.id + '/page/' + data.page + '.json');
      },
      'shreds:newsitem:render:show': function (ev, data) {
        render('newsitem', '/i/feeds/' + data.feed_id + '/' + data.id + '.json');
      }
    }
  };

  function render(context, url) {
    feedView.attr('data-template', context);
    Shreds.ajax.get(url, {
      failMsg: '<strong>Can\'t connect</strong> to server'
    }).done(function (data) {
      Shreds.loadModel(context, data);
      Shreds.syncView(context);
      document.title = '[shreds] - ' + (data.title || 'Feeds');
      if (container.scrollTop() > 0) {
        container.stop(true, true).animate({scrollTop: 0}, 850);
      }
    });
  }
})(window.Shreds);
