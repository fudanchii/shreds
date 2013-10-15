(function (Shreds) { 'use strict';
  var name = 'watch';
  Shreds.components.push(name);
  Shreds[name] = {
    list: [],
    add: function (data) {
      this.list.push(data);
      doWatch.call(this).fail(function () {
        var eventWatch = setInterval(function () {
          doWatch.call(this);
          if (this.list.length === 0) {
            clearInterval(eventWatch);
          }
        }.bind(this), 2000);
      }.bind(this));
    },
    init: function (ctx) {
      setInterval(doWatch.bind(this), 600000);
    }
  };

function doWatch() {
  return $.ajax('/i/watch.json', {
    data: { 'watchList': this.list.join() }
  }).done(function (data) {
    for (var key in data) {
      var action = key.split('-')[0];
      Shreds.$.trigger('shreds:' + action, data[key]);
    }
    this.list = this.list.filter(function (el) {
      return !data[el];
    });
  }.bind(this));
}

})(window.Shreds);


