(function ($, Class) {
  this.Widget = Class.extend({
    init: function (node) {
      if (typeof node === "undefined" ||
         ((node.length !== 1) && !(node instanceof $))) {
        throw "Need an HTML DOM node to attach widget.";
      }
      this.node = node;
      this.content = $("<div/>");
      this.rendered = false;
    },
    render: function () {
      this.node.empty();
      this.node.append(this.content.children());
    },
    flush: function () {
      this.content.empty();
    }
  });
})(jQuery, Class);
