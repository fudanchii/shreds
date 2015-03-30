import Component from 'framework/component';

import FeedsStore from 'shreds/stores/feeds';
import ScrollActions from 'shreds/actions/scroll';

const el = '[template=main-view]';

export default
class Feeds extends Component {
  static inject() {
    return {
      template: this.template('feeds'),
      data: FeedsStore.getData(),
      partials: {
        'newsitems': this.template('feeds/_newsitems')
      }
    };
  }

  oninit() {
    FeedsStore.addChangeListener((ev, data) => {
      if (this.rendered) {
        if (this.shouldRerender(data)) { return; }
        this.update();
        return;
      }
      this.render(el);
      setTimeout(() => { this.set('in', 'in'); }, 65);
    });

    this.on('render', () => {
      this.rendered = true;
    });

    this.on('unrender', () => {
      this.rendered = false;
    });
  }

  shouldRerender(data) {
    if (!data.flags.rerender) { return data.flags.rerender; }
    this.set('in', '');
    setTimeout(() => {
      this.update();
      this.set('in', 'in');
      ScrollActions.scrollUp();
    }, 400);
    return true;
  }

  static helpers() {
    return {
      unreadIcon(unread) {
        const icon = 'glyphicon-ok-';
        unread = unread === null || typeof(unread) === 'undefined' ? true : unread;
        return icon + (unread ? 'circle' : 'sign');
      },
      unreadLabel(unread) {
        unread = unread === null || typeof(unread) === 'undefined' ? true : unread;
        return unread ? 'read' : 'unread';
      }
    };
  }
}
