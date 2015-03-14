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
    this.on('navigate', (ev, path, c_id, f_id) => {
      NavigationActions.navigate(c_id, f_id);
    });
    this.on('mark-as-read', (ev, id) => {
      NavigationActions.markAsRead(id);
      return false;
    });
  }

  selectFeed(cid, fid) {
    if (this.selectedFeed) {
      this.set(this.selectedFeed, '');
    }
    this.selectedFeed = `categories[${cid}].feeds[${fid}].active`;
    this.set(this.selectedFeed, ' active');
  }

  static helpers() {
    return {
      countUnread: function countUnread(feeds) {
        const count = feeds.reduce((p, c, i, a) => (p + (c.unreadCount || 0)), 0);
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
