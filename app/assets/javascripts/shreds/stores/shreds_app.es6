import Store from 'framework/store';

const ShredsAppStore = new Store({
  oninit() {
    this.__data = {
      toDisplay: 'feeds'
    }
  }
});

export default ShredsAppStore;
