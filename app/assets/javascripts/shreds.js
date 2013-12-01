window.Shreds = {
  '$': $({}),
  components: [],
  models: {},

  init: function () {
    this.components.forEach(function (el, idx, arr) {
      this[el].init.call(this[el]);
      for (var ev in this[el].events) {
        this.$.on(ev, this[el].events[ev].bind(this[el]));
      }
    }.bind(this));
  },

  loadModel: function (name, data) {
    if (data instanceof Array) {
      var indexed = '$idx:-' + name;
      this.models[indexed] || (this.models[indexed] = {});
      this.models[indexed] = data.reduce(function (prev, cur, idx, arr) {
        prev[cur.id] = cur;
        return prev;
      }, this.models[indexed]);
      data.forEach(function (val, idx, arr) {
        for (var child in val.has) {
          this.loadModel.call(this, name + '/' + val.has[child], val[val.has[child]]);
        }
      }.bind(this));
    } else if (typeof data === 'object') {
      this.models[name] = data;
      for (var model in data) {
        this.loadModel.call(this, name + '/' + model, data[model]);
      }
    }
  },

  find: function (model, id) {
    return this.models['$idx:-' + model][id];
  },

  render: function (dom, template, data) {
    var options = arguments[3] || {};
    if (options.append) {
      dom.append(window.HandlebarsTemplates[template](data));
    } else {
      dom.html(window.HandlebarsTemplates[template](data));
    }
    Shreds.utils.tooltip();
    Shreds.utils.timeago();
  },

  syncView: function (template/*, data*/) {
    var data = arguments[1] || this.models[template];
    var options = arguments[2] || {};
    var container = $('[data-template="' + template + '"]');
    this.render(container, template, data, options);
  }
};
