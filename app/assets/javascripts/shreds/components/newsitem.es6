import Component from 'framework/component';
import Decorator from 'framework/decorator';

import NewsitemStore from 'shreds/stores/newsitem';

const NewsitemComponent = Component.extend({
  template: Component.template('newsitem'),

  data() { return NewsitemStore.getData(); },

  oninit() {
    NewsitemStore.addChangeListener((ev, payload) => {
      this.assign(payload.data);
      Decorator.do('setTitle', this.get('title'));
    });
    Decorator.do('setTitle', this.get('title'));
  }
});

export default NewsitemComponent;
