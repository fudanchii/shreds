(function (Shreds) { 'use strict';
  var name = 'navigation';
  Shreds.components.push(name);
  Shreds[name] = {
    events: {
      'shreds:markAsRead': function (ev, data) {
        if (data.error) {
          Shreds.notification.error(data.error);
        } else {
          var feed = Shreds.find('navigation/categories/feeds', data.feed.id);
          feed.unreadCount = data.feed.unreadCount;
          Shreds.notification.info(data.info);
          Shreds.syncView(name);
        }
      },
      'shreds:create': function (ev, data) {
        reloadNavigation(data);
        Shreds.subscription.stopSpinner();
      },
      'shreds:destroy': function (ev, data) {
        reloadNavigation(data);
      },
      'shreds:rmCategory': function (ev, data) {
        reloadNavigation(data);
      },
      'shreds:opml': function (ev, data) {
        reloadNavigation(data);
        $('#fileupload').trigger('spinnerstop');
      }
    },
    init: function () {
      Shreds.syncView(name);
    }
  };

  function reloadNavigation(data) {
    if (data.error) {
      Shreds.notification.error(data.error);
    } else {
      Shreds.loadModel('navigation', data.data);
      Shreds.syncView('navigation');
      Shreds.notification.info(data.info);
    }
  }
})(window.Shreds);

