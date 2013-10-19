(function (Shreds) { 'use strict';
  Shreds.action = {
    markAsRead: function (ev) {
      var id = this.data('id');
      this.parents('li').css('list-style-image', 'url(/assets/spinner.16x16.gif)');
      Shreds.ajax.patch('/i/feeds/' + id + '/mark_as_read.json', {
        doWatch: true,
        failMsg: '<strong>Can not</strong> mark this feed as read.'
      }).fail(function () {
        Shreds.syncView('navigation');
      });
    },
    removeCategory: function (ev) {
      var id = this.data('id');
      Shreds.ajax.delete('/i/categories/' + id + '.json', {
        doWatch: true,
        failMsg: '<strong>Can not</strong> remove this category.'
      });
    },
    subscribeTo: function (ev) {
      Shreds.subscription.activate.call(this[0]);
      ev.stopPropagation();
      return false;
    },
    unsubscribe: function (ev) {
      var id = this.data('id');
      Shreds.ajax.delete('/i/feeds/' + id + '.json', {
        doWatch: true,
        failMsg: '<strong>Can not</strong> unsubscribe to this feed.'
      });
    }
  };
})(window.Shreds);

