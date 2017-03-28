import Router from 'framework/router';

import ShredsDispatcher from 'shreds/dispatcher';
import { action } from 'framework/helpers/constants';
import { root_path } from 'shreds';

const RoutesService = new Router({
  oninit() {
    this.map(r => {
      r('categories');
      r('subscriptions', { path: '/backyard/subscriptions' });
      r('feeds', { path: root_path }, r => {
        r('page', { path: 'page/:page' });
        r('show', { path: ':feed_id' }, r => {
          r('page', { path: 'page/:page' });
          r('newsitem', { path: ':id' });
        });
      });
    });
  }
});

RoutesService.use(ShredsDispatcher, action.NAVIGATE_TO_ROUTE);

export default RoutesService;
