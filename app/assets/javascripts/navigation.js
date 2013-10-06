$(function () {
  var $doc = $(document);

  $('.rm-cat').on('click', function (ev) {
    var id = $(this).data('id');
    throwErrorIf(!id, "id not found");
    $.ajax('/i/categories/' + id + '.json', {
      type: 'DELETE'
    }).done(function () {
      location.reload();
    });
  });

  $('.mark-as-read').on('click', function (ev) {
    var id = $(this).data('id');
    throwErrorIf(!id, 'id not found: ' + id);
    $.ajax('/i/feeds/' + id + '/mark_as_read.json', {
      type: 'PATCH'
    }).done(function () {
      location.reload();
    });
  });

  $doc.on('shreds:create', function (ev, data) {
    console.log(data);
    $doc.trigger('shreds:subscription:spinner:stop');
    if (data.error) {
      $('.span-fixed-sidebar').prepend(
        $('<div class="alert alert-danger alert-float">' +
          '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
          data.error + '</div>'));
    } else {
      location.reload();
    }
  });
});
