/*
 * Action component.
 * At init, this component bind all event declared at data-on-* attribute
 * at html nodes.
 *
 */

(function (Shreds) { 'use strict';

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
  var $subscribeInput = $('#subscribeInput'),
      $subscribeForm =  $('#subscribe_form');

  /**
   * Previously selected feed (navigation sidebar)
   */
  var prevId  = null;

  /**
   * Since we want to handling events from all nodes in
   * a single call, we need some kind of generic function
   * which may route the function called depends on its event type.
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
      Shreds.action[name].call($this, ev);
    };
  }

  Shreds.registerComponent('action', {

    /**
     * We want to start handling events just when our main app initializing,
     * here we bind those events delegated via $(document)
     */
    init: function () {
      var $doc = $(document);
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

    markAllAsRead: function (ev) {
      Shreds.ajax.patch('/i/feeds/mark_all_as_read.json', {
        failMsg: '<strong>Can\'t</strong> mark all feed as read.'
      }).done(function (data) {
        Shreds.$.trigger('watch:markAllAsRead', data);
        Shreds.$.trigger('feeds:_storage:clear');
      });
    },

    markAsRead: function (ev) {
      var id = this.data('id');
      Shreds.render(this.siblings('.favicon'), 'spinner', {
        spinner: Shreds.assets.path('spinner16x16')
      });
      Shreds.ajax.patch('/i/feeds/' + id + '/mark_as_read.json', {
        failMsg: '<strong>Can\'t</strong> mark this feed as read.'
      }).done(function (data) {
        Shreds.$.trigger('watch:markAsRead', data);
        Shreds.$.trigger('feeds:_storage:clear');
      }).fail(function () {
        var feed = Shreds.model.find('navigation/categories/feeds', id);
        Shreds.syncView('navlist_item:'+id, feed);
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
      var
        $feedUrl =        $('#feed_url'),
        $categoryName =   $('#category_name');

      ev.preventDefault();
      if ($subscribeInput.is(':hidden')) {
        $subscribeInput.slideDown();
        $feedUrl.focus();
      } else {
        Shreds.subscription.startSpinner(this[0]);
        Shreds.ajax.post('/i/feeds.json', {
          doWatch: true,
          opts: { data: $subscribeForm.find('form').serialize() },
          failMsg: '<strong>Can\'t</strong> add feed at the moment.'
        }).fail(function () {
          Shreds.subscription.stopSpinner();
        });
        $feedUrl.val('');
        $categoryName.val('');
        $subscribeInput.slideUp();
      }
    },

    toggleRead: function (ev) {
      var id = this.data('id');
      var feedId = this.data('feedId');
      Shreds.ajax.patch('/i/feeds/' + feedId + '/' + id + '/toggle_read.json', {
        failMsg: '<strong>Can\'t mark</strong> this item as read.'
      }).done(function (data) {
        var feed = Shreds.model.find('navigation/categories/feeds', feedId);
        feed.unreadCount = data.feed.unreadCount;
        Shreds.syncView('navlist_item:'+feedId, feed);
        this.find('.glyphicon').toggleClass('glyphicon-ok-circle').toggleClass('glyphicon-ok-sign');
        Shreds.notification.info(data.info);
        Shreds.$.trigger('feeds:_storage:clear');
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
      if ($subscribeForm.has(ev.target).length === 0) { amOut = true; return; }
      amOut = false;
    }
  });
})(window.Shreds);

