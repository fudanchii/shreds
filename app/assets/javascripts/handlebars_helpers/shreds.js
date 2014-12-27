(function (Handlebars) {

  Handlebars.registerHelper('unreadIcon', function (unread) {
    var icon = 'glyphicon-ok-';
    unread = unread == null || typeof(unread) == 'undefined' ? true : unread;
    return icon + (unread ? 'circle' : 'sign');
  });

  Handlebars.registerHelper('unreadLabel', function (unread) {
    unread = unread == null || typeof(unread) == 'undefined' ? true : unread;
    return unread ? 'read' : 'unread';
  });

  Handlebars.registerHelper('readableDate', function (dateStr) {
    var date = new Date((dateStr || '').replace(/-/g, '/').replace(/[TZ]/g, ' ') + ' UTC');
    return date.toDateString() + ", " + date.toLocaleTimeString();
  });

  Handlebars.registerHelper('countUnread', function (feeds) {
    var count = 0;
    count = feeds.reduce(function (p, c, i, a) {
      return p + (c.unreadCount || 0);
    }, 0);
    return count + '';
  });

  Handlebars.registerHelper('ifsingular', function (cond, options) {
    if (cond == 1) { return options.fn(this); }
    return options.inverse(this);
  });

})(window.Handlebars);
