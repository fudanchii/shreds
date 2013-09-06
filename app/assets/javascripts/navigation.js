$(function () {
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
});
