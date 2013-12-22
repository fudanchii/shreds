window.Shreds = {
  '$': $({}),
  components: [],

  init: function () {
    this.components.forEach(function (el, idx, arr) {
      this[el].init.call(this[el]);
      for (var ev in this[el].events) {
        this.$.on(ev, this[el].events[ev].bind(this[el]));
      }
    }.bind(this));
  },

  render: function (dom, template, data/*, options*/) {
    var options = arguments[3] || {};
    if (options.append) {
      dom.append(window.HandlebarsTemplates[template](data));
    } else {
      dom.html(window.HandlebarsTemplates[template](data));
    }
    Shreds.utils.tooltip();
    Shreds.utils.timeago();
  },

  syncView: function (template/*, data, options*/) {
    var data = arguments[1] || Shreds.model.get(template);
    var options = arguments[2] || {};
    var container = $('[data-template="' + template + '"]');
    this.render(container, template, data, options);
  }
};
