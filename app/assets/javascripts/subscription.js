$(function () {
  var $subscribeInput = $('#subscribeInput');
  var $subscribeForm = $('#subscribe_form');
  var amOut = true;
  $('#btnSubmitFeed').on('click', function (e) {
    if ($subscribeInput.is(':hidden')) {
      $subscribeInput.slideDown();
      $('#feed_url').focus();
      e.stopPropagation();
      return false;
    };
  });
  $(document).on('mouseup', function (e) {
    if (!$subscribeInput.is(':hidden') && amOut) {
      $subscribeInput.slideUp();
    }
  });
  $(document).on('mouseover', function (e) {
    if ($subscribeForm.has(e.target).length === 0) {
      amOut = true;
      return;
    }
    amOut = false;
  });
});
