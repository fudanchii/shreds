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
    var indexed = '_idx_' + name;
    if (data instanceof Array) {
      this.models[indexed] || (this.models[indexed] = {});
      this.models[indexed] = data.reduce(function (prev, cur, idx, arr) {
        prev[cur.id] = cur;
        return prev;
      }, this.models[indexed]);
      data.forEach(function (val, idx, arr) {
        for (var child in val.has) {
          this.loadModel.call(this, val.has[child], val[val.has[child]]);
        }
      }.bind(this));
    } else if (typeof data === 'object') {
      this.models[name] = data;
      for (var model in data) {
        this.loadModel.call(this, model, data[model]);
      }
    }
  },

  find: function (model, id) {
    return this.models['_idx_' + model][id];
  },

  syncView: function (template/*, data*/) {
    var data = arguments[1] || this.models[template];
    var options = arguments[2] || {};
    var container = $('[data-template=' + template + ']');
    if (options.append) {
      container.append(window.HandlebarsTemplates[template](data));
    } else {
      container.html(window.HandlebarsTemplates[template](data));
    }
  }
};
