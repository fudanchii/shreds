import Ractive from 'Ractive';
import { basename, join } from 'framework/helpers/path';

const modules = require.s.contexts._;

Ractive.defaults.data = {
  component(name) {
    if (!!this.partials[name]) { return name; }
    this.partials[name] = `<${name}/>`;
    return name;
  }
};

let Component = Ractive.extend({});

Object.assign(Component, {
  prefix: '',

  _templates: window.RactiveTemplates,

  template(name) {
    const
      tplName = join(this.prefix, 'templates', name);
    return this._templates[tplName];
  },

  addComponent(c) {
    const
      args = [null].concat(c.Class.inject()),
      cc = c.Class.bind.apply(c.Class, args);
    for (var k in c.Class) {
      cc[k] = c.Class[k];
    }
    cc._parent = c.Class._parent;
    cc.defaults = c.Class.defaults;
    this.components[basename(c.Name)] = cc;
  },

  addHelpers(props) {
    Object.assign(this.defaults.data, props);
  },

  loader(options) {
    const
      prefix = options.prefix || 'app',
      namespace = join(prefix, 'components'),
      rgx = new RegExp(`^${namespace}/`);

    let result = [];

    this.prefix = prefix;
    for (var k in modules.defined) {
      if (rgx.test(k)) {
        result.push({
          Name: k,
          Class: modules.defined[k]
        });
      }
    }
    for (var k in modules.registry) {
      if (rgx.test(k)) {
        result.push({
          Name: k,
          Class: require(k)
        });
      }
    }
    result.forEach((c, i, a) => {
      this.addComponent(c);
      this.addHelpers(c.Class.helpers());
    });
  },

  inject() {},

  helpers() {}
});

export default Component;
