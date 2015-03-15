import Ractive from 'Ractive';
import { join } from 'framework/helpers/path';

const modules = require.s.contexts._;

let Component = Ractive.extend({});

Component.addHelpers = function addHelpers(props) {
  for (var k in props) {
    this.defaults.data[k] = props[k];
  }
};

Component._templates = window.RactiveTemplates;

Component.template = function Template(name) {
  const
    tplName = join(this.prefix, 'templates', name);
  return this._templates[tplName];
}

Component.loader = function loader(options) {
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
  return result;
}

Component.inject = function () {};
Component.helpers = function () {};

export default Component;
