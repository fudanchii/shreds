
const actionRegistry = {};

const Decorator = {
  do(name, ...args) {
    if (kind(actionRegistry[name]) === 'Function') {
      actionRegistry[name].apply(null, args);
    }
  },

  add(name, fn) {
    actionRegistry[name] = fn;
  }
};

export default Decorator;
