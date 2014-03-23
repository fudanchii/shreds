(function (Shreds) { 'use strict';
  var name = 'utils';
  var stateId = 0;
  var nameSpace = "shreds-";

  Shreds.components.push(name);
  Shreds[name] = {
    init: function () {
      $.scrollUp({
        scrollSpeed: 850,
        easingType: 'easeOutCubic',
        scrollTitle: 'Back to top',
        scrollText: '<i class="glyphicon glyphicon-chevron-up"></i>',
      });
    },
    events: {
      'shreds:prerender': function (ev, data) {
        Shreds.utils.tooltip('destroy');
        Shreds.utils.timeago('dispose');
        /**
         * In some rare cases, when `Shreds.render' kicks-in
         * while tooltip is still active, bootstrap wont managed
         * to remove that tooltip. Do it manually here. */
        $('body > .tooltip').remove();
      },
      'shreds:postrender': function (ev, data) {
        Shreds.utils.tooltip({ container: 'body' });
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
