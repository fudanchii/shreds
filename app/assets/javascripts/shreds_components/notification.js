(function (Shreds) { 'use strict';
  Shreds.registerComponent('notification', {
    init: function () { },
    error: function (msg) {
      notify('danger', msg);
    },
    info: function (msg) {
      notify('info', msg);
    }
  });

  function notify(type, message) {
    var ident = Shreds.utils.generateId(name);
    var notification = null;
    Shreds.syncView(name,
      { text: message, type: type, id: ident },
      { append: true });
    setTimeout(function () {
      notification = $('#' + ident).addClass('in');
    }, 150);
    setTimeout(function () {
      notification.removeClass('in');
    }, 5150);
    setTimeout(function () {
      notification.remove();
    }, 6300);
  }
})(window.Shreds);

