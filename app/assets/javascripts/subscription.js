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
          failMsg: '<strong>Can not</strong> add feed at the moment.'
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

    $doc.on('mousedown', function (e) {
      if (!$subscribeInput.is(':hidden') && amOut) {
        $subscribeInput.slideUp();
      }
    });
    $doc.on('mouseover', function (e) {
      if ($subscribeForm.has(e.target).length === 0) {
        return amOut = true;
      }
      amOut = false;
    });
  }
})(window.Shreds);

