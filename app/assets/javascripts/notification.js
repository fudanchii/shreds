(function (Shreds) { 'use strict';
  var name = 'notification';
  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {
    },
    error: function (msg) {
      notify('danger', msg);
    },
    info: function (msg) {
      notify('info', msg);
    }
  };

  function notify(type, message) {
    Shreds.syncView(name,
      { text: message, type: type },
      { append: true });
    setTimeout(function () {
      $('.alert-float').addClass('in');
    }, 200);
  }
})(window.Shreds);

