(function (Shreds) { 'use strict';
  var stateId = 0;
  var nameSpace = "shreds-";

  Shreds.registerComponent('utils', {
    init: function () {
      $.scrollUp({
        scrollSpeed: 850,
        easingType: 'easeOutCubic',
        scrollTitle: 'Back to top',
        scrollText: '<i class="glyphicon glyphicon-chevron-up"></i>',
      });
    },
    events: {
      'shreds:prerender': function (ev, data) {
        Shreds.utils.tooltip('destroy');
        Shreds.utils.timeago('dispose');
        /**
         * In some rare cases, when `Shreds.render' kicks-in
         * while tooltip is still active, bootstrap wont managed
         * to remove that tooltip. Do it manually here. */
        $('body > .tooltip').remove();
      },
      'shreds:postrender': function (ev, data) {
        Shreds.utils.tooltip({ container: 'body' });
        Shreds.utils.timeago();
      },
      'shreds:progress:start': function (ev, data) {
        window.NProgress.start();
        window.NProgress.set(0.6);
      },
      'shreds:progress:done': function (ev, data) {
        window.NProgress.done();
      },
      'shreds:feed:postrender': function (ev, data) {
        $('.feed-content img').each(function (idx) {
          var
            $this = $(this),
            href, url;

          if ($this.attr('src').match(/^(https?:)?\/\//)) {
            return;
          }

          href = $this.parentsUntil('.feed').last()
                      .siblings('.panel-heading').find('a:last-child')[0];
          url = Shreds.utils.urlJoin(href, $this.attr('src'));
          $this.attr('src', url);
        });
      }
    },
    generateId: function (name) {
      return nameSpace + name + '-' + stateId++;
    },
    tooltip: function (option) {
      $('[data-toggle=tooltip]').tooltip(option);
    },
    timeago: function (option) {
      $('abbr.timeago').timeago(option);
    },
    urlJoin: function (url, path) {
      var rurl = '';
      if (path.match(/^\//)) {
        console.log('absolute');
        rurl = url.hostname + path;
      } else {
        console.log('relative');
        rurl = url.hostname + url.pathname.replace(/([^\/]*)$/, '') + path;
      }
      return url.protocol + '//' + rurl;
    }
  });

})(window.Shreds);
