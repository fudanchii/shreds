(function (Shreds) {
  var name = 'model';
  var index_prefix = '$idx:-';
  var Models = {};

  Shreds.components.push(name);

  Shreds[name] = {
    init: function () { },

    import: function (modelName, data) {
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
})(window.Shreds);
