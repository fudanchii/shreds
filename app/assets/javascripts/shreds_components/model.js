(function (Shreds) { 'mode strict';
  var name = 'model';
  var index_prefix = '$idx:-';
  var Models = {};
  var Context = {};

  Shreds.components.push(name);

  Shreds[name] = {
    init: function () { },

    import: function (modelName, data, options) {
      cleanUpContext(modelName, options);
      if (data instanceof Array) {
        var indexed = index_prefix + modelName;
        Models[indexed] || (Models[indexed] = {});
        Models[indexed] = data.reduce(function (prev, curr, idx, arr) {
          prev[curr.id] = curr;
          return prev;
        }, Models[indexed]);
        data.forEach(function (val, idx, arr) {
          for (var child in val.has) {
            this.import.call(this, modelName + '/' + val.has[child], val[val.has[child]]);
          }
        }.bind(this));
      } else if (typeof data === 'object') {
        Models[modelName] = data;
        for (var model in data) {
          this.import.call(this, modelName + '/' + model, data[model]);
        }
      }
    },

    find: function (model, id) {
      return Models[index_prefix + model][id];
    },

    get: function (name) {
      return Models[name];
    }
  };

  function cleanUpContext(modelName, options) {
    if (!options || !options.context) { return; }
    var ctx = Context[options.context];
    if (ctx) {
      for (var key in Models) {
        if ((new RegExp('^' + ctx + '/')).test(key)) {
          delete(Models[key]);
        } else if ((new RegExp('^\\$idx:\\-' + ctx + '/')).test(key)) {
          delete(Models[key]);
        }
      }
      delete(Models[ctx]);
      delete(Models[index_prefix + ctx]);
    }
    Context[options.context] = modelName;
  }
})(window.Shreds);
