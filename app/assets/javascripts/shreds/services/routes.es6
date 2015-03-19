import Router from 'lib/assets/framework/router';

const RouteService = new Router({
  oninit() {
    this.map(r => {
      r('categories');
      r('subscriptions', { path: '/backyard/subscriptions' });
      r('feeds', { path: '/' }, r => {
        r('index', { path: 'page/:page' });
        r('show', { path: ':feed_id' });
        r('showNewsitem', { path: ':feed_id/:id' });
      });
    });
  },

  feeds: {
    index(args) {
    },

    show(args) {
    },

    showNewsitem(args) {
    }
  },

  subscriptions: {
    index(args) {
    }
  },

  categories: {
    index(args) {
    }
  }
});

export default RouteService;
