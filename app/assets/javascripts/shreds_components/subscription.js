(function (Shreds) { 'use strict';
  var name = 'subscription';
  var spinner = null;

  Shreds.components.push(name);
  Shreds[name] = {
    startSpinner: function (el) {
      spinner = Ladda.create(el);
      spinner.start();
    },
    stopSpinner: function () { spinner.stop(); },
    init: function () { setupFileUpload(); }
  };

  function setupFileUpload() {
    var spinner = Ladda.create($('.fileinput-button')[0]);

    $('#fileupload').fileupload({ dataType: 'json' })
      .on('fileuploadstart', function () { spinner.start(); })
      .on('fileuploaddone', function (e, data) {
        var result = data.result;
        if (result && result.error) {
          Shreds.notification.error(result.error);
          spinner.stop();
        } else if (result && result.watch) { Shreds.watch.add(result.watch); }
      })
      .on('fileuploadfail', function () {
        Shreds.notification.error('<strong>Can\'t</strong> upload file.');
        spinner.stop();
      })
      .on('spinnerstop', function () { spinner.stop(); });
  }
})(window.Shreds);

