(function (Shreds) {
  var stateId = 0;
  var nameSpace = "shreds-";

  Shreds.utils = {
    generateId: function (name) {
      return nameSpace + name + '-' + stateId++;
    },
    tooltip: function () {
      $('[data-toggle=tooltip]').tooltip();
    },
    timeago: function () {
      $('abbr.timeago').timeago();
    }
  };

})(window.Shreds);
