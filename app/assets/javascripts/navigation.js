$(function () {
  $('.rm-cat').on('click', function (ev) {
    var id = $(ev.target).data('id');
    if (!id) {
      throw new Error("id not found");
    }
    $.ajax('/i/categories/' + id + '.json', {
      type: 'DELETE'
    }).done(function () {
      location.reload();
    });
  });
});
