import Ractive from 'Ractive';
import { basename, join } from 'framework/helpers/path';

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

  setup(options) {
    this.prefix = options.prefix || 'app';
    this.setDebug(options.debug);
  },

  setDebug(isdebug) {
    Ractive.DEBUG = !!isdebug;
  },

  template(name) {
    const
      tplName = join(this.prefix, 'templates', name);
    return this._templates[tplName];
  },

  addComponent(c) {
    this.components[basename(c.Name)] = c.Class;
  },

  addHelpers(props) {
    Object.assign(this.defaults.data, props);
  },

  loader(options) {
    module.loadNamespace(join(this.prefix, 'components'), (result) => {
      result.forEach((c, i, a) => {
        this.addComponent(c);
      });
    });
  }
});


Object.assign(Component.prototype, {
  assign(object) {
    for (var k in object) {
      if (kind(object[k]) === 'Function') {
        continue;
      }
      this.set(k, object[k]);
    }
  }
});


export default Component;
