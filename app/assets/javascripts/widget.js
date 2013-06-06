(function ($, Class) {
  this.Widget = Class.extend({
    init: function (node) {
      if (typeof node === "undefined" ||
         ((node.length !== 1) && !(node instanceof $))) {
        throw "Need an HTML DOM node to attach widget.";
      }
      this.node = node;
      this.content = null;
    },
    render: function () {
      this.node.append(this.content);
    }
  });
}).call(window, jQuery, Class);
