(function (Shreds) { 'mode strict';
  var name = 'utils';
  var stateId = 0;
  var nameSpace = "shreds-";

  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {},
    events: {
      'shreds:prerender': function (ev, data) {
        Shreds.utils.tooltip('destroy');
        Shreds.utils.timeago('dispose');
      },
      'shreds:postrender': function (ev, data) {
        Shreds.utils.tooltip();
        Shreds.utils.timeago();
      }
    },
    generateId: function (name) {
      return nameSpace + name + '-' + stateId++;
    },
    tooltip: function (option) {
      $('[data-toggle=tooltip]').tooltip(option);
    },
    timeago: function (option) {
      $('abbr.timeago').timeago(option);
    }
  };

})(window.Shreds);
