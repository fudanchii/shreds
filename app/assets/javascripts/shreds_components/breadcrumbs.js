(function (Shreds) { 'use strict';
  var name = 'breadcrumbs';
  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {},
    events: {
      'route:dispatched': function (ev, data) {
        var fid = parseInt(data.feed_id, 10);
        var navdata = Shreds.model.get('navigation');
        var feed = Shreds.model.find('navigation/categories/feeds', fid);
        var category = null;
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
        };
        Shreds.syncView(name, { category: category, feed: feed });
      }
    }
  };
})(window.Shreds);
