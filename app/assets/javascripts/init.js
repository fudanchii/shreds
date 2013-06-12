(function ($, Widget) {
  $(function () {
    $("[widget-type]").each(function (idx, element) {
      var $element = $(element),
          _class   = $element.attr("widget-type"),
          widget   = null;
      if ((typeof window[_class] === "function") &&
          (window[_class] instanceof Widget)) {
        widget = new window[_class]($element);
        if (!widget.rendered) widget.render();
      }
    })
  })
}(jQuery, Widget));
