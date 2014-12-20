(function (Shreds) { 'use strict';
  var name = 'breadcrumbs';
  Shreds.registerComponent(name, {
    init: function () {},
    events: {
      'route:dispatched': function (ev, data) {
        var category, feed, navdata;
        var fid = parseInt(data.feed_id, 10);
        category = null;
        if (fid) {
          feed = Shreds.model.find('navigation/categories/feeds', fid);
          navdata = Shreds.model.get('navigation');
          for (var el in navdata.categories) {
            for (var f in navdata.categories[el].feeds) {
              if (navdata.categories[el].feeds[f].id == fid) {
                category = navdata.categories[el];
                break;
              }
            }
            if (category !== null) {
              break;
            }
          }
        }
        Shreds.syncView(name, { category: category, feed: feed });
      }
    }
  });
})(window.Shreds);
