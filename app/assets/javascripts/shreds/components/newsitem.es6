import Component from 'framework/component';
import Decorator from 'framework/decorator';

import NewsitemStore from 'shreds/stores/newsitem';
import FeedActions from 'shreds/actions/feed';

const NewsitemComponent = Component.extend({
  template: Component.template('newsitem'),

  data() { return NewsitemStore.get(); },

  oninit() {
    NewsitemStore.addChangeListener((ev, payload) => {
      this.assign(payload.data);
      Decorator.do('setTitle', this.get('title'));
    });

    this.on('mark-as-read', (ev, cid, sid, fid, nid, unread) => {
      FeedActions.markAsRead(cid, sid, fid, nid, unread);
      return false;
    });

    Decorator.do('setTitle', this.get('title'));
  }
});

export default NewsitemComponent;
