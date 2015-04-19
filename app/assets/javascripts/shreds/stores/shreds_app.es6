import Store from 'framework/store';

const ShredsAppStore = new Store({
  viewChange(viewName, callback) {
    this.load({ toDisplay: viewName });
    this.emitChange({ callable: callback });
  }
});

export default ShredsAppStore;
