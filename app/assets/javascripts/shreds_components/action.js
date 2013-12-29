/*
 * Action component.
 * At init, this component bind all event declared at data-on-* attribute
 * at html nodes.
 *
 */

(function (Shreds) { 'use strict';

  /** @const */
  var name = 'action';

  /**
   * List of our acknowledged events.
   * Since we have to create handler for each events,
   * here we call `act` function to create a closure just for that.
   * @const
   */
  var actOn= {
    click:      act('onClick'),
    mouseenter: act('onMouseenter'),
    mouseleave: act('onMouseleave'),
    mouseover:  act('onMouseover'),
    mousedown:  act('onMousedown'),
    mouseup:    act('onMouseup'),
    keyup:      act('onKeyup'),
    keydown:    act('onKeydown')
  };

  /**
   * Check if we're out from subscription form region
   * @type {boolean}
   */
  var amOut = true;

  /**
   * jQuery objects used throughout actions
   */
  var $doc = $(document),
      $subscribeInput = $('#subscribeInput'),
      $subscribeForm =  $('#subscribe_form'),
      $feedUrl =        $('#feed_url'),
      $categoryName =   $('#category_name');

  /**
   * Previously selected feed
   */
  var prevId  = null;

  /**
   * Since we want to handling events from all nodes in
   * a single call, we need some kind of generic function
   * which depends on its event type.
   * Here is how we create that function.
   *
   * Note that unlike native event handler, we bind the actual
   * handler to jQueryfied DOM-node instead of native DOM.
   *
   * @return {Function}
   */
  function act(attr) {
    return function (ev) {
      var $this = $(this);
      var name = $this.data(attr);
      if (!name) { return; }
      if (name === 'init') { throw 'Can\'t call init from events.' }
      return Shreds.action[name].call($this, ev);
    };
  }

  Shreds.components.push(name);

  Shreds[name] = {

    /**
     * We want to start handling events just when our main app initializing,
     * here we bind those events delegated via $(document)
     */
    init: function () {
      for (var k in actOn) { $doc.on(k, '[data-on-' + k + ']', actOn[k]); };
    },

    /**
     * Sometimes, rather than do something,
     * we just want to not propagating some event
     */
    doNotPropagate: function (ev) {
      ev.stopPropagation();
    },

    navigated: function (ev) {
      var model = null;
      Shreds.navigation.deactivate(prevId);
      prevId = this.data('feedId');
      Shreds.navigation.activate(prevId);
      this.find('.feed-title > a').trigger('click');
    },

    toTheFront: function (ev) {
      Shreds.navigation.deactivate(prevId);
      prevId = null;
      this.addClass('active');
      this.find('a').trigger('click');
    },

    markAsRead: function (ev) {
      var id = this.data('id');
      Shreds.render(this.siblings('.favicon'), 'spinner',
                    { spinner: Shreds.assets.path('spinner16x16') });
      Shreds.ajax.patch('/i/feeds/' + id + '/mark_as_read.json', {
        doWatch: true,
        failMsg: '<strong>Can\'t</strong> mark this feed as read.'
      }).fail(function () {
        Shreds.syncView('navigation');
      });
    },

    removeCategory: function (ev) {
      var id = this.data('id');
      Shreds.ajax.delete('/i/categories/' + id + '.json', {
        doWatch: true,
        failMsg: '<strong>Can\'t</strong> remove this category.'
      });
    },

    subscribeTo: function (ev) {
      if ($subscribeInput.is(':hidden')) {
        $subscribeInput.slideDown();
        $feedUrl.focus();
      } else {
        Shreds.subscription.startSpinner(this[0]);
        Shreds.ajax.post('/i/feeds.json', {
          doWatch: true,
          opts: { data: $subscribeForm.find('form').serialize() },
          failMsg: '<strong>Can\'t</strong> add feed at the moment.'
        }).fail(function () { Shreds.subscription.stopSpinner(); });
        $feedUrl.val('');
        $categoryName.val('');
        $subscribeInput.slideUp();
      }
      ev.preventDefault();
    },

    toggleRead: function (ev) {
      var id = this.data('id');
      var feedId = this.data('feedId');
      Shreds.ajax.patch('/i/feeds/' + feedId + '/' + id + '/toggle_read.json', {
        failMsg: '<strong>Can\'t mark</strong> this item as read.'
      }).done(function (data) {
        var feed = Shreds.model.find('navigation/categories/feeds', feedId);
        feed.unreadCount = data.feed.unreadCount;
        Shreds.syncView('navigation');
        this.find('.glyphicon').toggleClass('glyphicon-ok-circle').toggleClass('glyphicon-ok-sign');
        Shreds.notification.info(data.info);
        Shreds.$.trigger('shreds:feeds:_storage:clear');
      }.bind(this));
    },

    unsubscribe: function (ev) {
      var id = this.data('id');
      Shreds.ajax.delete('/i/feeds/' + id + '.json', {
        doWatch: true,
        failMsg: '<strong>Can\'t</strong> unsubscribe to this feed.'
      });
    },

    uploadOPML: function (ev) {
      $('#fileupload').trigger('click');
    },

    needSlideUp: function (ev) {
      if ($subscribeInput.is(':visible') && amOut) {
        $subscribeInput.slideUp();
      }
    },

    amOut: function (ev) {
      if ($subscribeForm.has(ev.target).length === 0) { return amOut = true; }
      amOut = false;
    }
  };
})(window.Shreds);

