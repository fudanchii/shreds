(function (Shreds) { 'use strict';
  Shreds.action = {
    markAsRead: function (ev) {
      var id = this.data('id');
      this.parents('li').css('list-style-image', Shreds.assets.url('spinner16x16'));
      Shreds.ajax.patch('/i/feeds/' + id + '/mark_as_read.json', {
        doWatch: true,
        failMsg: '<strong>Can\'t</strong> mark this feed as read.'
      }).fail(function () {
        Shreds.syncView('navigation');
      });
    },
    removeCategory: function (ev) {
      var id = this.data('id');
      Shreds.ajax.delete('/i/categories/' + id + '.json', {
        doWatch: true,
        failMsg: '<strong>Can\'t</strong> remove this category.'
      });
    },
    subscribeTo: function (ev) {
      Shreds.subscription.activate.call(this[0]);
      ev.stopPropagation();
      return false;
    },
    toggleRead: function (ev) {
      var id = this.data('id');
      var feedId = this.data('feedId');
      Shreds.ajax.patch('/i/feeds/' + feedId + '/' + id + '/toggle_read.json', {
        failMsg: '<strong>Can\'t mark</strong> this item as read.'
      }).done(function (data) {
        var feed = Shreds.find('feeds', feedId);
        feed.unreadCount = data.feed.unreadCount;
        Shreds.syncView('navigation');
        this.find('.glyphicon').toggleClass('glyphicon-ok-circle').toggleClass('glyphicon-ok-sign');
        Shreds.notification.info(data.info);
      }.bind(this));
    },
    unsubscribe: function (ev) {
      var id = this.data('id');
      Shreds.ajax.delete('/i/feeds/' + id + '.json', {
        doWatch: true,
        failMsg: '<strong>Can\'t</strong> unsubscribe to this feed.'
      });
    },
    uploadOPML: function (ev) {
      $('#fileupload').trigger('click');
    }
  };
})(window.Shreds);

