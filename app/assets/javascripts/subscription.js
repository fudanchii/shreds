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
        $.ajax('/i/feeds.json', {
          method: 'POST',
          data: $subscribeForm.find('form').serialize()
        }).done(function (data) {
          if (data && data.watch) {
            Shreds.watch.add(data.watch);
          }
        }).fail(function () {
          spinner.stop();
          Shreds.notification.error('<strong>Can not</strong> add feed at the moment.');
        });
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

    $doc.on('mousedown', function (e) {
      if (!$subscribeInput.is(':hidden') && amOut) {
        $subscribeInput.slideUp();
      }
    });
    $doc.on('mouseover', function (e) {
      if ($subscribeForm.has(e.target).length === 0) {
        amOut = true;
        return;
      }
      amOut = false;
    });
  }
})(window.Shreds);

