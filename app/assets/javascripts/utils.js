(function (Shreds) {
  var stateId = 0;
  var nameSpace = "shreds-"
  Shreds.utils = {
    generateId: function (name) {
      return nameSpace + name + '-' + stateId++;
    }
  };
})(window.Shreds);
