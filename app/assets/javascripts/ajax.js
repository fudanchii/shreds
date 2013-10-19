(function (Shreds) {
  var name = 'ajax';
  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {
    },
    'do': function (url, opts) {
      var ajax = $.ajax(url, opts.ajax);
      if (opts.doWatch) {
        ajax.done(function (data) {
          if (data && data.watch) {
            Shreds.watch.add(data.watch);
          }
        });
      }
      if (opts.failMsg) {
        ajax.fail(function () {
          Shreds.notification.error(opts.failMsg);
        })
      }
      return ajax;
    },
    get: function (url, opts) {
      var options = $.extend({}, opts, {
        ajax: { type: 'GET' }
      });
      return this.do(url, options);
    },
    post: function (url, opts) {
      var options = $.extend({}, opts, {
        ajax: { type: 'POST' }
      });
      return this.do(url, options);
    },
    patch: function (url, opts) {
      var options = $.extend({}, opts, {
        ajax: { type: 'PATCH' }
      });
      return this.do(url, options);
    },
    'delete': function (url, opts) {
      var options = $.extend({}, opts, {
        ajax: { type: 'DELETE' }
      });
      return this.do(url, options);
    }
  };
})(window.Shreds);
