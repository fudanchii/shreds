import Store from 'framework/store';
import NavigationActions from 'shreds/actions/navigation';

import { action } from 'shreds/constants';

let NavigationStore = new Store();

let tokens = {};
tokens[action.NAVIGATE] = NavigationActions.dispatcher.register(action.NAVIGATE, [], function (payload) {
                            if (this.selectedFeed) {
                              this.__data.categories[this.selectedFeed.cid].feeds[this.selectedFeed.fid].active = '';
                            }
                            this.__data.categories[payload.cid].feeds[payload.fid].active = ' active';
                            this.selectedFeed = { cid: payload.cid, fid: payload.fid };
                            this.emitChange();
                          }.bind(NavigationStore));

NavigationStore.dispatchTokens = tokens;

export default NavigationStore
