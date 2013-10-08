function Notification($doc) {
  var $container = $('.alert-container');
  var notif = '<div class="alert fade alert-float"/>';
  var close = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';

  function notify($notif, message) {
    $notif.html(close + message);
    $container.append($notif);
    setTimeout(function () { $notif.addClass('in'); }, 100);
  }

  $doc.on('shreds:notification:error', function (ev, message) {
    var $notif = $(notif).addClass('alert-danger');
    notify($notif, message);
  });

  $doc.on('shreds:notification:info', function (ev, message) {
    var $notif = $(notif).addClass('alert-info');
    notify($notif, message);
  });
}
