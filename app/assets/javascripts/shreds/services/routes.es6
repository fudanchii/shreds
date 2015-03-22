import Router from 'framework/router';

import ShredsDispatcher from 'shreds/dispatcher';

const RoutesService = new Router({
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
  }
});

RoutesService.dispatcher = ShredsDispatcher;

export default RoutesService;
