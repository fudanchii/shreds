function doWatch() {
  return $.ajax('/i/watch.json', {
    data: { 'watchList': this.watchList.join() }
  }).done(function (data) {
    for (key in data) {
      var action = key.split('-')[0];
      this.trigger('shreds:' + action, data[key]);
    }
    this.watchList = this.watchList.filter(function (el) {
      return !data[el];
    });
  }.bind(this));
}

function Watch($shreds) {
  $shreds.watchList = [];
  var theWatch = setInterval(doWatch.bind($shreds), 600000);

  $shreds.on('shreds:addWatch', function (ev, data) {
    $shreds.watchList.push(data);
    doWatch.call($shreds).fail(function () {
      // For longer background process at server, the first 
      // doWatch.call might get failed. Schedule the next
      // doWatch to run in every 3 seconds.
      var eventWatch = setInterval(function () {
        doWatch.call($shreds).done(function () { clearInterval(eventWatch); });
      }, 3000);
    });
  });
}
