(function (Shreds) {
  var name = 'ajax';
  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {
      $.ajaxPrefilter(function (opts, oriOpts, xhr) {
        if (!opts.crossDomain) {
          var token = $('meta[name="csrf-token"]').attr('content');
          if (token) { xhr.setRequestHeader('X-CSRF-Token', token); }
        }
      });
    },
    'do': function (url, opts) {
      var ajax = $.ajax(url, opts.opts);
      if (opts.doWatch) {
        ajax.done(function (data) { if (data && data.watch) { Shreds.watch.add(data.watch); } });
      }
      if (opts.failMsg) {
        ajax.fail(function () { Shreds.notification.error(arguments[2] || opts.failMsg); });
      }
      return ajax;
    },
    get: function (url, opts) {
      var options = $.extend(true, {}, opts, { opts: { type: 'GET' } });
      return this.do(url, options);
    },
    post: function (url, opts) {
      var options = $.extend(true, {}, opts, { opts: { type: 'POST' } });
      return this.do(url, options);
    },
    patch: function (url, opts) {
      var options = $.extend(true, {}, opts, { opts: { type: 'PATCH' } });
      return this.do(url, options);
    },
    'delete': function (url, opts) {
      var options = $.extend(true, {}, opts, { opts: { type: 'DELETE' } });
      return this.do(url, options);
    }
  };
})(window.Shreds);
