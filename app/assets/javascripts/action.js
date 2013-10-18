(function (Shreds) { 'use strict';
  Shreds.action = {
    markAsRead: function (ev) {
      var id = this.data('id');
      this.parents('li').css('list-style-image', 'url(/assets/spinner.16x16.gif)');
      $.ajax('/i/feeds/' + id + '/mark_as_read.json', {
        type: 'PATCH'
      }).done(function (data) {
        if (data && data.watch) {
          Shreds.watch.add(data.watch);
        }
      });
    },
    removeCategory: function (ev) {
      var id = this.data('id');
      $.ajax('/i/categories/' + id + '.json', {
        type: 'DELETE'
      }).done(function (data) {
        if (data && data.watch) {
          Shreds.watch.add(data.watch);
        }
      });
    },
    subscribeTo: function (ev) {
      Shreds.subscription.activate.call(this[0]);
      ev.stopPropagation();
      return false;
    },
    unsubscribe: function (ev) {
      var id = this.data('id');
      $.ajax('/i/feeds/' + id + '.json', {
        type: 'DELETE'
      }).done(function (data) {
        if (data && data.watch) {
          Shreds.watch.add(data.watch);
        }
      });
    }
  };
})(window.Shreds);
