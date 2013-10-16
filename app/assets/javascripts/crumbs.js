(function (shreds) {
  shreds.components.push('crumbs');
  shreds.crumbs = {
    init: function (ctx) {
      $('.nav-buttons > button').tooltip();
      $('abbr.timeago').timeago();
    }
  };
})(window.Shreds);
