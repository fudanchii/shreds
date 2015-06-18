import Router from 'framework/router';

import ShredsDispatcher from 'shreds/dispatcher';

const RoutesService = new Router({
  oninit() {
    this.map(r => {
      r('categories');
      r('subscriptions', { path: '/backyard/subscriptions' });
      r('feeds', { path: '/' }, r => {
        r('page', { path: 'page/:page' });
        r('show', { path: ':feed_id' }, r => {
          r('page', { path: 'page/:page' });
          r('newsitem', { path: ':id' });
        });
      });
    });
  }
});

RoutesService.dispatcher = ShredsDispatcher;

export default RoutesService;
