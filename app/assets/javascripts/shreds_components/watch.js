(function (Shreds) { 'use strict';
  Shreds.registerComponent('watch', {
    list: [],
    add: function (data) {
      this.list.push(data);
      setTimeout(doWatch.bind(this), 1000);
    },
    init: function (ctx) {
      setInterval(doWatch.bind(this, 'updateFeed'), 600000);
    }
  });

function doWatch(key) {
  if (key) { this.list.push(key); }
  if (this.list.length === 0) { return; }
  $.ajax('/i/watch.json', {
    data: { 'watchList': this.list.join() }
  }).done(function (data) {
    Shreds.$.trigger('feeds:_storage:clear');
    for (var key in data) {
      var action = key.split('-')[0];
      Shreds.$.trigger(name + ':' + action, data[key]);
    }
    this.list = this.list.filter(function (el) {
      return !data[el];
    });
  }.bind(this)).fail(function () {
    if (key) { this.list.shift(); return; }
    setTimeout(doWatch.bind(this), 2000);
  }.bind(this));
}

})(window.Shreds);

