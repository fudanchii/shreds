
const actionRegistry = {};

const Decorator = {
  do(name, ...args) {
    if (_.isFunction(actionRegistry[name])) {
      actionRegistry[name].apply(null, args);
    }
  },

  add(name, fn) {
    actionRegistry[name] = fn;
  }
};

export default Decorator;
