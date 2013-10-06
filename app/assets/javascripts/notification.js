$(function () {
  var $doc = $(document);
  var $container = $('.alert-container');
  var notif = '<div class="alert fade alert-float"/>';
  var close = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';

  $doc.on('shreds:notification:error', function (ev, message) {
    var $notif = $(notif).addClass('alert-danger');
    $notif.html(close + message);
    $container.append($notif);
    setTimeout(function () { $notif.addClass('in'); }, 100);
  });
});
