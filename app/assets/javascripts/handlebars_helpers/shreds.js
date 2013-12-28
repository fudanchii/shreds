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

})(window.Handlebars);
