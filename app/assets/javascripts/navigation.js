function Navigation($shreds) {
  $('.rm-cat').on('click', function (ev) {
    var id = $(this).data('id');
    Assert(id, "id not found");
    $.ajax('/i/categories/' + id + '.json', {
      type: 'DELETE'
    }).done(function () {
      location.reload();
    });
  });

  $('.mark-as-read').on('click', function (ev) {
    var id = $(this).data('id');
    Assert(id, 'id not found: ' + id);
    $.ajax('/i/feeds/' + id + '/mark_as_read.json', {
      type: 'PATCH'
    }).done(function () {
      location.reload();
    });
  });

  $shreds.on('shreds:create', function (ev, data) {
    if (data.error) {
      $shreds.trigger('shreds:notification:error', data.error);
    } else {
      location.reload();
    }
    $shreds.trigger('shreds:subscription:spinner:stop');
  });
}
