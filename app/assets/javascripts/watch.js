function Watch($shreds) {
  var watchList = [];
  var theWatch = setInterval(function () {
    $.ajax('/i/watch.json', {
      data: { 'watchList': watchList.join() }
    }).done(function (data) {
      for (key in data) {
        var action = key.split('-')[0];
        $shreds.trigger('shreds:' + action, data[key]);
      }
      watchList = watchList.filter(function (el) {
        return !data[el];
      });
    });
  }, 10000);

  $shreds.on('shreds:addWatch', function (ev, data) {
    watchList.push(data);
  });
}