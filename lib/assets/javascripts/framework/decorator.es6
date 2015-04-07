
const actionRegistry = {};

const Decorator = {
  do(name) {
    if (kind(actionRegistry[name]) === 'Function') {
      actionRegistry[name]();
    }
  },

  add(name, fn) {
    actionRegistry[name] = fn;
  }
};

export default Decorator
