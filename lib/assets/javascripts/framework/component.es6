import Ractive from 'Ractive';
import { join } from 'framework/helpers/path';

const modules = require.s.contexts._;

let Component = Ractive.extend({});

Object.assign(Component, {
  prefix: '',

  _templates: window.RactiveTemplates,

  template(name) {
    const
      tplName = join(this.prefix, 'templates', name);
    return this._templates[tplName];
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
      this.addHelpers(c.Class.helpers());
    });
    return result;
  },

  inject() {},

  helpers() {}
});

export default Component;
