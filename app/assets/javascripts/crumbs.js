(function (shreds) {
  shreds.components.push('crumbs');
  shreds.crumbs = {
    init: function (ctx) {
      $('[data-toggle=tooltip]').tooltip();
      $('abbr.timeago').timeago();
    }
  };
})(window.Shreds);
