/*
 * Shreds main application.
 * Shreds utilizing components as its building block.
 * Each shreds's component is a plain old javascript object
 * with init function as its `constructor'.
 *
 * Components registered by pushing its name to `Shreds.components' list.
 * As an example shreds component may be written roughly like this:
 *
 * var name = test;
 * Shreds.components.push(name);
 * Shreds[name] = {
 *   init: function () {
 *     console.log('test component initiated.');
 *   }
 * }
 *
 * Shreds use facade-like pattern to do inter-components communication.
 * Each component may define `events' object which will be available
 * under `Shreds.$'. Later in your code you may invoke the event handler
 * by `triggering' the event like this:
 *
 * Shreds.$.trigger(eventname, data);
 *
 */

window.Shreds = {

  // Event sandbox, a jQuery object.
  '$': $({}),

  // components name list.
  components: [],

  // Shreds's `constructor'.
  // This function will iterate the components list and call init function
  // from each component. `init' will also bind component's event to `Shreds.$'
  init: function () {
    this.components.forEach(function (el, idx, arr) {
      this[el].init.call(this[el]);
      for (var ev in this[el].events) {
        this.$.on(ev, this[el].events[ev].bind(this[el]));
      }
    }.bind(this));
  },

  // Render handlebars template under the given dom object.
  // Optionally checking if we want to append the template instead of
  // replacing the whole dom's content.
  render: function (dom, template, data/*, options*/) {
    var options = arguments[3] || {};
    if (options.append) {
      dom.append(window.HandlebarsTemplates[template](data));
    } else {
      dom.html(window.HandlebarsTemplates[template](data));
    }
    // FIXME: These 2 lines don't fit here.
    Shreds.utils.tooltip();
    Shreds.utils.timeago();
  },

  // Synchronize template and its data,
  // which also means re-render the template.
  syncView: function (template/*, data, options*/) {
    var data = arguments[1] || Shreds.model.get(template);
    var options = arguments[2] || {};
    var container = $('[data-template="' + template + '"]');
    this.render(container, template, data, options);
  }
};
