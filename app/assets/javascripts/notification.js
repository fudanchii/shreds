$(function () {
  var $doc = $(document);
  var $container = $('.alert-container');

  $doc.on('shreds:notification:error', function (ev, message) {
    var $notif = $('<div class="alert alert-danger fade alert-float"/>');
    var close = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';
    $notif.html(close + message);
    $container.append($notif);
    setTimeout(function () { $notif.addClass('in'); }, 100);
  });
});
