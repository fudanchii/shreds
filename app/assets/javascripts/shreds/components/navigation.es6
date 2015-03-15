import Component from 'framework/component';
import NavigationStore from 'shreds/stores/navigation';
import NavigationActions from 'shreds/actions/navigation';

import moment from 'moment';

export default
class Navigation extends Component {
  static inject() {
    return {
      el: '[template=navigation]',
      template: this.template('navigation'),
      data: NavigationStore.getData()
    };
  }

  oninit() {
    NavigationStore.addChangeListener((ev, data) => {
      this.update();
    });
    this.on('navigate', (ev, path, cid, fid) => {
      NavigationActions.navigate(path, cid, fid);
    });
    this.on('mark-as-read', (ev, cid, fid) => {
      NavigationActions.markAsRead(cid, fid);
      return false;
    });
  }

  static helpers() {
    return {
      countUnread: function countUnread(feeds) {
        let count = 0;
        for (var k in feeds) {
          count += feeds[k].unreadCount || 0;
        }
        return count + '';
      },
      readableDate: function readableDate(dateStr) {
        return moment(dateStr).format('dddd, MMMM Do YYYY, HH:mm:ss');
      },
      momentFormat: function momentFormat(dateStr) {
        return moment(dateStr).fromNow(true);
      }
    };
  }
}
