(function (Shreds) {
  var name = 'subscription';

  var $subscribeInput = $('#subscribeInput');
  var $subscribeForm = $('#subscribe_form');
  var $feedUrl = $('#feed_url');
  var $categoryName = $('#category_name');
  var spinner = null;

  Shreds.components.push(name);
  Shreds[name] = {
    activate: function () {
      if ($subscribeInput.is(':hidden')) {
        $subscribeInput.slideDown();
        $feedUrl.focus();
      } else {
        spinner = Ladda.create(this);
        spinner.start();
        Shreds.ajax.post('/i/feeds.json', {
          doWatch: true,
          opts: { data: $subscribeForm.find('form').serialize() },
          failMsg: '<strong>Can\'t</strong> add feed at the moment.'
        }).fail(function () { spinner.stop(); });
        $feedUrl.val('');
        $categoryName.val('');
        $subscribeInput.slideUp();
      }
    },
    stopSpinner: function () {
      try {
        spinner.stop();
      } catch (e) { }
    },
    init: function () {
      setupDOMEvents();
    }
  };

  function setupDOMEvents() {
    var $doc = $(document);
    var amOut = true;
    var spinner = Ladda.create($('.fileinput-button')[0]);

    $doc.on('mousedown', function (e) {
      if ($subscribeInput.is(':visible') && amOut) {
        $subscribeInput.slideUp();
      }
    });
    $doc.on('mouseover', function (e) {
      if ($subscribeForm.has(e.target).length === 0) {
        return amOut = true;
      }
      amOut = false;
    });
    $('#fileupload').fileupload({
      dataType: 'json'
    }).on('fileuploadstart', function () {
      spinner.start();
    }).on('fileuploaddone', function (e, data) {
      var result = data.result;
      if (result && result.error) {
        Shreds.notification.error(result.error);
        spinner.stop();
      } else if (result && result.watch) { Shreds.watch.add(result.watch); }
    }).on('fileuploadfail', function () {
      Shreds.notification.error('<strong>Can\'t</strong> upload file.');
      spinner.stop();
    }).on('spinnerstop', function () { spinner.stop(); });
  }
})(window.Shreds);

