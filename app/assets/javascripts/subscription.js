$(function () {
  $('#btnSubmitFeed').on('click', function (e) {
    var $subscribeInput = $('#subscribeInput');
    if ($subscribeInput.is(':hidden')) {
      $subscribeInput.show();
      $('#feed_url').focus();
      e.stopPropagation();
      return false;
    };
  })
});
