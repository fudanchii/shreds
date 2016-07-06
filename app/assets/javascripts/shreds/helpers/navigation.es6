import moment from 'moment';

import Component from 'framework/component';

Component.addHelpers({
  countUnread: function countUnread(feeds) {
    let count = 0;
    for (var k in feeds) {
      count += feeds[k].unread_count || 0;
    }
    return count + '';
  },

  readableDate: function readableDate(dateStr) {
    return moment(dateStr).format('dddd, MMMM Do YYYY, HH:mm:ss');
  },

  momentFormat: function momentFormat(dateStr) {
    return moment(dateStr).fromNow(true);
  }
});
