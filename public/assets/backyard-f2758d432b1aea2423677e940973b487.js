+function(t){"use strict";function e(){var t=document.createElement("bootstrap"),e={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd otransitionend",transition:"transitionend"};for(var o in e)if(void 0!==t.style[o])return{end:e[o]}}t.fn.emulateTransitionEnd=function(e){var o=!1,i=this;t(this).one(t.support.transition.end,function(){o=!0});var n=function(){o||t(i).trigger(t.support.transition.end)};return setTimeout(n,e),this},t(function(){t.support.transition=e()})}(jQuery),+function(t){"use strict";var e='[data-dismiss="alert"]',o=function(o){t(o).on("click",e,this.close)};o.prototype.close=function(e){function o(){s.trigger("closed.bs.alert").remove()}var i=t(this),n=i.attr("data-target");n||(n=i.attr("href"),n=n&&n.replace(/.*(?=#[^\s]*$)/,""));var s=t(n);e&&e.preventDefault(),s.length||(s=i.hasClass("alert")?i:i.parent()),s.trigger(e=t.Event("close.bs.alert")),e.isDefaultPrevented()||(s.removeClass("in"),t.support.transition&&s.hasClass("fade")?s.one(t.support.transition.end,o).emulateTransitionEnd(150):o())};var i=t.fn.alert;t.fn.alert=function(e){return this.each(function(){var i=t(this),n=i.data("bs.alert");n||i.data("bs.alert",n=new o(this)),"string"==typeof e&&n[e].call(i)})},t.fn.alert.Constructor=o,t.fn.alert.noConflict=function(){return t.fn.alert=i,this},t(document).on("click.bs.alert.data-api",e,o.prototype.close)}(jQuery),+function(t){"use strict";var e=function(e,o){this.options=o,this.$element=t(e),this.$backdrop=this.isShown=null,this.options.remote&&this.$element.load(this.options.remote)};e.DEFAULTS={backdrop:!0,keyboard:!0,show:!0},e.prototype.toggle=function(t){return this[this.isShown?"hide":"show"](t)},e.prototype.show=function(e){var o=this,i=t.Event("show.bs.modal",{relatedTarget:e});this.$element.trigger(i),this.isShown||i.isDefaultPrevented()||(this.isShown=!0,this.escape(),this.$element.on("click.dismiss.modal",'[data-dismiss="modal"]',t.proxy(this.hide,this)),this.backdrop(function(){var i=t.support.transition&&o.$element.hasClass("fade");o.$element.parent().length||o.$element.appendTo(document.body),o.$element.show(),i&&o.$element[0].offsetWidth,o.$element.addClass("in").attr("aria-hidden",!1),o.enforceFocus();var n=t.Event("shown.bs.modal",{relatedTarget:e});i?o.$element.find(".modal-dialog").one(t.support.transition.end,function(){o.$element.focus().trigger(n)}).emulateTransitionEnd(300):o.$element.focus().trigger(n)}))},e.prototype.hide=function(e){e&&e.preventDefault(),e=t.Event("hide.bs.modal"),this.$element.trigger(e),this.isShown&&!e.isDefaultPrevented()&&(this.isShown=!1,this.escape(),t(document).off("focusin.bs.modal"),this.$element.removeClass("in").attr("aria-hidden",!0).off("click.dismiss.modal"),t.support.transition&&this.$element.hasClass("fade")?this.$element.one(t.support.transition.end,t.proxy(this.hideModal,this)).emulateTransitionEnd(300):this.hideModal())},e.prototype.enforceFocus=function(){t(document).off("focusin.bs.modal").on("focusin.bs.modal",t.proxy(function(t){this.$element[0]===t.target||this.$element.has(t.target).length||this.$element.focus()},this))},e.prototype.escape=function(){this.isShown&&this.options.keyboard?this.$element.on("keyup.dismiss.bs.modal",t.proxy(function(t){27==t.which&&this.hide()},this)):this.isShown||this.$element.off("keyup.dismiss.bs.modal")},e.prototype.hideModal=function(){var t=this;this.$element.hide(),this.backdrop(function(){t.removeBackdrop(),t.$element.trigger("hidden.bs.modal")})},e.prototype.removeBackdrop=function(){this.$backdrop&&this.$backdrop.remove(),this.$backdrop=null},e.prototype.backdrop=function(e){var o=this.$element.hasClass("fade")?"fade":"";if(this.isShown&&this.options.backdrop){var i=t.support.transition&&o;if(this.$backdrop=t('<div class="modal-backdrop '+o+'" />').appendTo(document.body),this.$element.on("click.dismiss.modal",t.proxy(function(t){t.target===t.currentTarget&&("static"==this.options.backdrop?this.$element[0].focus.call(this.$element[0]):this.hide.call(this))},this)),i&&this.$backdrop[0].offsetWidth,this.$backdrop.addClass("in"),!e)return;i?this.$backdrop.one(t.support.transition.end,e).emulateTransitionEnd(150):e()}else!this.isShown&&this.$backdrop?(this.$backdrop.removeClass("in"),t.support.transition&&this.$element.hasClass("fade")?this.$backdrop.one(t.support.transition.end,e).emulateTransitionEnd(150):e()):e&&e()};var o=t.fn.modal;t.fn.modal=function(o,i){return this.each(function(){var n=t(this),s=n.data("bs.modal"),a=t.extend({},e.DEFAULTS,n.data(),"object"==typeof o&&o);s||n.data("bs.modal",s=new e(this,a)),"string"==typeof o?s[o](i):a.show&&s.show(i)})},t.fn.modal.Constructor=e,t.fn.modal.noConflict=function(){return t.fn.modal=o,this},t(document).on("click.bs.modal.data-api",'[data-toggle="modal"]',function(e){var o=t(this),i=o.attr("href"),n=t(o.attr("data-target")||i&&i.replace(/.*(?=#[^\s]+$)/,"")),s=n.data("modal")?"toggle":t.extend({remote:!/#/.test(i)&&i},n.data(),o.data());e.preventDefault(),n.modal(s,this).one("hide",function(){o.is(":visible")&&o.focus()})}),t(document).on("show.bs.modal",".modal",function(){t(document.body).addClass("modal-open")}).on("hidden.bs.modal",".modal",function(){t(document.body).removeClass("modal-open")})}(jQuery),+function(t){"use strict";function e(){t(i).remove(),t(n).each(function(e){var i=o(t(this));i.hasClass("open")&&(i.trigger(e=t.Event("hide.bs.dropdown")),e.isDefaultPrevented()||i.removeClass("open").trigger("hidden.bs.dropdown"))})}function o(e){var o=e.attr("data-target");o||(o=e.attr("href"),o=o&&/#/.test(o)&&o.replace(/.*(?=#[^\s]*$)/,""));var i=o&&t(o);return i&&i.length?i:e.parent()}var i=".dropdown-backdrop",n="[data-toggle=dropdown]",s=function(e){t(e).on("click.bs.dropdown",this.toggle)};s.prototype.toggle=function(i){var n=t(this);if(!n.is(".disabled, :disabled")){var s=o(n),a=s.hasClass("open");if(e(),!a){if("ontouchstart"in document.documentElement&&!s.closest(".navbar-nav").length&&t('<div class="dropdown-backdrop"/>').insertAfter(t(this)).on("click",e),s.trigger(i=t.Event("show.bs.dropdown")),i.isDefaultPrevented())return;s.toggleClass("open").trigger("shown.bs.dropdown"),n.focus()}return!1}},s.prototype.keydown=function(e){if(/(38|40|27)/.test(e.keyCode)){var i=t(this);if(e.preventDefault(),e.stopPropagation(),!i.is(".disabled, :disabled")){var s=o(i),a=s.hasClass("open");if(!a||a&&27==e.keyCode)return 27==e.which&&s.find(n).focus(),i.click();var r=t("[role=menu] li:not(.divider):visible a",s);if(r.length){var l=r.index(r.filter(":focus"));38==e.keyCode&&l>0&&l--,40==e.keyCode&&l<r.length-1&&l++,~l||(l=0),r.eq(l).focus()}}}};var a=t.fn.dropdown;t.fn.dropdown=function(e){return this.each(function(){var o=t(this),i=o.data("bs.dropdown");i||o.data("bs.dropdown",i=new s(this)),"string"==typeof e&&i[e].call(o)})},t.fn.dropdown.Constructor=s,t.fn.dropdown.noConflict=function(){return t.fn.dropdown=a,this},t(document).on("click.bs.dropdown.data-api",e).on("click.bs.dropdown.data-api",".dropdown form",function(t){t.stopPropagation()}).on("click.bs.dropdown.data-api",n,s.prototype.toggle).on("keydown.bs.dropdown.data-api",n+", [role=menu]",s.prototype.keydown)}(jQuery),+function(t){"use strict";var e=function(t,e){this.type=this.options=this.enabled=this.timeout=this.hoverState=this.$element=null,this.init("tooltip",t,e)};e.DEFAULTS={animation:!0,placement:"top",selector:!1,template:'<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',trigger:"hover focus",title:"",delay:0,html:!1,container:!1},e.prototype.init=function(e,o,i){this.enabled=!0,this.type=e,this.$element=t(o),this.options=this.getOptions(i);for(var n=this.options.trigger.split(" "),s=n.length;s--;){var a=n[s];if("click"==a)this.$element.on("click."+this.type,this.options.selector,t.proxy(this.toggle,this));else if("manual"!=a){var r="hover"==a?"mouseenter":"focus",l="hover"==a?"mouseleave":"blur";this.$element.on(r+"."+this.type,this.options.selector,t.proxy(this.enter,this)),this.$element.on(l+"."+this.type,this.options.selector,t.proxy(this.leave,this))}}this.options.selector?this._options=t.extend({},this.options,{trigger:"manual",selector:""}):this.fixTitle()},e.prototype.getDefaults=function(){return e.DEFAULTS},e.prototype.getOptions=function(e){return e=t.extend({},this.getDefaults(),this.$element.data(),e),e.delay&&"number"==typeof e.delay&&(e.delay={show:e.delay,hide:e.delay}),e},e.prototype.getDelegateOptions=function(){var e={},o=this.getDefaults();return this._options&&t.each(this._options,function(t,i){o[t]!=i&&(e[t]=i)}),e},e.prototype.enter=function(e){var o=e instanceof this.constructor?e:t(e.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type);return clearTimeout(o.timeout),o.hoverState="in",o.options.delay&&o.options.delay.show?void(o.timeout=setTimeout(function(){"in"==o.hoverState&&o.show()},o.options.delay.show)):o.show()},e.prototype.leave=function(e){var o=e instanceof this.constructor?e:t(e.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type);return clearTimeout(o.timeout),o.hoverState="out",o.options.delay&&o.options.delay.hide?void(o.timeout=setTimeout(function(){"out"==o.hoverState&&o.hide()},o.options.delay.hide)):o.hide()},e.prototype.show=function(){var e=t.Event("show.bs."+this.type);if(this.hasContent()&&this.enabled){if(this.$element.trigger(e),e.isDefaultPrevented())return;var o=this.tip();this.setContent(),this.options.animation&&o.addClass("fade");var i="function"==typeof this.options.placement?this.options.placement.call(this,o[0],this.$element[0]):this.options.placement,n=/\s?auto?\s?/i,s=n.test(i);s&&(i=i.replace(n,"")||"top"),o.detach().css({top:0,left:0,display:"block"}).addClass(i),this.options.container?o.appendTo(this.options.container):o.insertAfter(this.$element);var a=this.getPosition(),r=o[0].offsetWidth,l=o[0].offsetHeight;if(s){var d=this.$element.parent(),h=i,p=document.documentElement.scrollTop||document.body.scrollTop,c="body"==this.options.container?window.innerWidth:d.outerWidth(),u="body"==this.options.container?window.innerHeight:d.outerHeight(),f="body"==this.options.container?0:d.offset().left;i="bottom"==i&&a.top+a.height+l-p>u?"top":"top"==i&&a.top-p-l<0?"bottom":"right"==i&&a.right+r>c?"left":"left"==i&&a.left-r<f?"right":i,o.removeClass(h).addClass(i)}var m=this.getCalculatedOffset(i,a,r,l);this.applyPlacement(m,i),this.$element.trigger("shown.bs."+this.type)}},e.prototype.applyPlacement=function(t,e){var o,i=this.tip(),n=i[0].offsetWidth,s=i[0].offsetHeight,a=parseInt(i.css("margin-top"),10),r=parseInt(i.css("margin-left"),10);isNaN(a)&&(a=0),isNaN(r)&&(r=0),t.top=t.top+a,t.left=t.left+r,i.offset(t).addClass("in");var l=i[0].offsetWidth,d=i[0].offsetHeight;if("top"==e&&d!=s&&(o=!0,t.top=t.top+s-d),/bottom|top/.test(e)){var h=0;t.left<0&&(h=-2*t.left,t.left=0,i.offset(t),l=i[0].offsetWidth,d=i[0].offsetHeight),this.replaceArrow(h-n+l,l,"left")}else this.replaceArrow(d-s,d,"top");o&&i.offset(t)},e.prototype.replaceArrow=function(t,e,o){this.arrow().css(o,t?50*(1-t/e)+"%":"")},e.prototype.setContent=function(){var t=this.tip(),e=this.getTitle();t.find(".tooltip-inner")[this.options.html?"html":"text"](e),t.removeClass("fade in top bottom left right")},e.prototype.hide=function(){function e(){"in"!=o.hoverState&&i.detach()}var o=this,i=this.tip(),n=t.Event("hide.bs."+this.type);return this.$element.trigger(n),n.isDefaultPrevented()?void 0:(i.removeClass("in"),t.support.transition&&this.$tip.hasClass("fade")?i.one(t.support.transition.end,e).emulateTransitionEnd(150):e(),this.$element.trigger("hidden.bs."+this.type),this)},e.prototype.fixTitle=function(){var t=this.$element;(t.attr("title")||"string"!=typeof t.attr("data-original-title"))&&t.attr("data-original-title",t.attr("title")||"").attr("title","")},e.prototype.hasContent=function(){return this.getTitle()},e.prototype.getPosition=function(){var e=this.$element[0];return t.extend({},"function"==typeof e.getBoundingClientRect?e.getBoundingClientRect():{width:e.offsetWidth,height:e.offsetHeight},this.$element.offset())},e.prototype.getCalculatedOffset=function(t,e,o,i){return"bottom"==t?{top:e.top+e.height,left:e.left+e.width/2-o/2}:"top"==t?{top:e.top-i,left:e.left+e.width/2-o/2}:"left"==t?{top:e.top+e.height/2-i/2,left:e.left-o}:{top:e.top+e.height/2-i/2,left:e.left+e.width}},e.prototype.getTitle=function(){var t,e=this.$element,o=this.options;return t=e.attr("data-original-title")||("function"==typeof o.title?o.title.call(e[0]):o.title)},e.prototype.tip=function(){return this.$tip=this.$tip||t(this.options.template)},e.prototype.arrow=function(){return this.$arrow=this.$arrow||this.tip().find(".tooltip-arrow")},e.prototype.validate=function(){this.$element[0].parentNode||(this.hide(),this.$element=null,this.options=null)},e.prototype.enable=function(){this.enabled=!0},e.prototype.disable=function(){this.enabled=!1},e.prototype.toggleEnabled=function(){this.enabled=!this.enabled},e.prototype.toggle=function(e){var o=e?t(e.currentTarget)[this.type](this.getDelegateOptions()).data("bs."+this.type):this;o.tip().hasClass("in")?o.leave(o):o.enter(o)},e.prototype.destroy=function(){this.hide().$element.off("."+this.type).removeData("bs."+this.type)};var o=t.fn.tooltip;t.fn.tooltip=function(o){return this.each(function(){var i=t(this),n=i.data("bs.tooltip"),s="object"==typeof o&&o;n||i.data("bs.tooltip",n=new e(this,s)),"string"==typeof o&&n[o]()})},t.fn.tooltip.Constructor=e,t.fn.tooltip.noConflict=function(){return t.fn.tooltip=o,this}}(jQuery),+function(t){"use strict";var e=function(o,i){this.$element=t(o),this.options=t.extend({},e.DEFAULTS,i)};e.DEFAULTS={loadingText:"loading..."},e.prototype.setState=function(t){var e="disabled",o=this.$element,i=o.is("input")?"val":"html",n=o.data();t+="Text",n.resetText||o.data("resetText",o[i]()),o[i](n[t]||this.options[t]),setTimeout(function(){"loadingText"==t?o.addClass(e).attr(e,e):o.removeClass(e).removeAttr(e)},0)},e.prototype.toggle=function(){var t=this.$element.closest('[data-toggle="buttons"]'),e=!0;if(t.length){var o=this.$element.find("input");"radio"===o.prop("type")&&(o.prop("checked")&&this.$element.hasClass("active")?e=!1:t.find(".active").removeClass("active")),e&&o.prop("checked",!this.$element.hasClass("active")).trigger("change")}e&&this.$element.toggleClass("active")};var o=t.fn.button;t.fn.button=function(o){return this.each(function(){var i=t(this),n=i.data("bs.button"),s="object"==typeof o&&o;n||i.data("bs.button",n=new e(this,s)),"toggle"==o?n.toggle():o&&n.setState(o)})},t.fn.button.Constructor=e,t.fn.button.noConflict=function(){return t.fn.button=o,this},t(document).on("click.bs.button.data-api","[data-toggle^=button]",function(e){var o=t(e.target);o.hasClass("btn")||(o=o.closest(".btn")),o.button("toggle"),e.preventDefault()})}(jQuery),+function(t){"use strict";var e=function(o,i){this.$element=t(o),this.options=t.extend({},e.DEFAULTS,i),this.transitioning=null,this.options.parent&&(this.$parent=t(this.options.parent)),this.options.toggle&&this.toggle()};e.DEFAULTS={toggle:!0},e.prototype.dimension=function(){var t=this.$element.hasClass("width");return t?"width":"height"},e.prototype.show=function(){if(!this.transitioning&&!this.$element.hasClass("in")){var e=t.Event("show.bs.collapse");if(this.$element.trigger(e),!e.isDefaultPrevented()){var o=this.$parent&&this.$parent.find("> .panel > .in");if(o&&o.length){var i=o.data("bs.collapse");if(i&&i.transitioning)return;o.collapse("hide"),i||o.data("bs.collapse",null)}var n=this.dimension();this.$element.removeClass("collapse").addClass("collapsing")[n](0),this.transitioning=1;var s=function(){this.$element.removeClass("collapsing").addClass("in")[n]("auto"),this.transitioning=0,this.$element.trigger("shown.bs.collapse")};if(!t.support.transition)return s.call(this);var a=t.camelCase(["scroll",n].join("-"));this.$element.one(t.support.transition.end,t.proxy(s,this)).emulateTransitionEnd(350)[n](this.$element[0][a])}}},e.prototype.hide=function(){if(!this.transitioning&&this.$element.hasClass("in")){var e=t.Event("hide.bs.collapse");if(this.$element.trigger(e),!e.isDefaultPrevented()){var o=this.dimension();this.$element[o](this.$element[o]())[0].offsetHeight,this.$element.addClass("collapsing").removeClass("collapse").removeClass("in"),this.transitioning=1;var i=function(){this.transitioning=0,this.$element.trigger("hidden.bs.collapse").removeClass("collapsing").addClass("collapse")};return t.support.transition?void this.$element[o](0).one(t.support.transition.end,t.proxy(i,this)).emulateTransitionEnd(350):i.call(this)}}},e.prototype.toggle=function(){this[this.$element.hasClass("in")?"hide":"show"]()};var o=t.fn.collapse;t.fn.collapse=function(o){return this.each(function(){var i=t(this),n=i.data("bs.collapse"),s=t.extend({},e.DEFAULTS,i.data(),"object"==typeof o&&o);n||i.data("bs.collapse",n=new e(this,s)),"string"==typeof o&&n[o]()})},t.fn.collapse.Constructor=e,t.fn.collapse.noConflict=function(){return t.fn.collapse=o,this},t(document).on("click.bs.collapse.data-api","[data-toggle=collapse]",function(e){var o,i=t(this),n=i.attr("data-target")||e.preventDefault()||(o=i.attr("href"))&&o.replace(/.*(?=#[^\s]+$)/,""),s=t(n),a=s.data("bs.collapse"),r=a?"toggle":i.data(),l=i.attr("data-parent"),d=l&&t(l);a&&a.transitioning||(d&&d.find('[data-toggle=collapse][data-parent="'+l+'"]').not(i).addClass("collapsed"),i[s.hasClass("in")?"addClass":"removeClass"]("collapsed")),s.collapse(r)})}(jQuery),function(t){"function"==typeof define&&define.amd?define(["jquery"],t):t(jQuery)}(function(t){function e(){var e=o(this),a=s.settings;return isNaN(e.datetime)||(0==a.cutoff||n(e.datetime)<a.cutoff)&&t(this).text(i(e.datetime)),this}function o(e){if(e=t(e),!e.data("timeago")){e.data("timeago",{datetime:s.datetime(e)});var o=t.trim(e.text());s.settings.localeTitle?e.attr("title",e.data("timeago").datetime.toLocaleString()):!(o.length>0)||s.isTime(e)&&e.attr("title")||e.attr("title",o)}return e.data("timeago")}function i(t){return s.inWords(n(t))}function n(t){return(new Date).getTime()-t.getTime()}t.timeago=function(e){return i(e instanceof Date?e:"string"==typeof e?t.timeago.parse(e):"number"==typeof e?new Date(e):t.timeago.datetime(e))};var s=t.timeago;t.extend(t.timeago,{settings:{refreshMillis:6e4,allowFuture:!1,localeTitle:!1,cutoff:0,strings:{prefixAgo:null,prefixFromNow:null,suffixAgo:"ago",suffixFromNow:"from now",seconds:"less than a minute",minute:"about a minute",minutes:"%d minutes",hour:"about an hour",hours:"about %d hours",day:"a day",days:"%d days",month:"about a month",months:"%d months",year:"about a year",years:"%d years",wordSeparator:" ",numbers:[]}},inWords:function(e){function o(o,n){var s=t.isFunction(o)?o(n,e):o,a=i.numbers&&i.numbers[n]||n;return s.replace(/%d/i,a)}var i=this.settings.strings,n=i.prefixAgo,s=i.suffixAgo;this.settings.allowFuture&&0>e&&(n=i.prefixFromNow,s=i.suffixFromNow);var a=Math.abs(e)/1e3,r=a/60,l=r/60,d=l/24,h=d/365,p=45>a&&o(i.seconds,Math.round(a))||90>a&&o(i.minute,1)||45>r&&o(i.minutes,Math.round(r))||90>r&&o(i.hour,1)||24>l&&o(i.hours,Math.round(l))||42>l&&o(i.day,1)||30>d&&o(i.days,Math.round(d))||45>d&&o(i.month,1)||365>d&&o(i.months,Math.round(d/30))||1.5>h&&o(i.year,1)||o(i.years,Math.round(h)),c=i.wordSeparator||"";return void 0===i.wordSeparator&&(c=" "),t.trim([n,p,s].join(c))},parse:function(e){var o=t.trim(e);return o=o.replace(/\.\d+/,""),o=o.replace(/-/,"/").replace(/-/,"/"),o=o.replace(/T/," ").replace(/Z/," UTC"),o=o.replace(/([\+\-]\d\d)\:?(\d\d)/," $1$2"),o=o.replace(/([\+\-]\d\d)$/," $100"),new Date(o)},datetime:function(e){var o=t(e).attr(s.isTime(e)?"datetime":"title");return s.parse(o)},isTime:function(e){return"time"===t(e).get(0).tagName.toLowerCase()}});var a={init:function(){var o=t.proxy(e,this);o();var i=s.settings;i.refreshMillis>0&&(this._timeagoInterval=setInterval(o,i.refreshMillis))},update:function(o){var i=s.parse(o);t(this).data("timeago",{datetime:i}),s.settings.localeTitle&&t(this).attr("title",i.toLocaleString()),e.apply(this)},updateFromDOM:function(){t(this).data("timeago",{datetime:s.parse(t(this).attr(s.isTime(this)?"datetime":"title"))}),e.apply(this)},dispose:function(){this._timeagoInterval&&(window.clearInterval(this._timeagoInterval),this._timeagoInterval=null)}};t.fn.timeago=function(t,e){var o=t?a[t]:a.init;if(!o)throw new Error("Unknown function name '"+t+"' for timeago");return this.each(function(){o.call(this,e)}),this},document.createElement("abbr"),document.createElement("time")}),jQuery.timeago.settings.strings={prefixAgo:null,prefixFromNow:null,suffixAgo:"ago",suffixFromNow:"from now",seconds:"%d seconds",minute:"a minute",minutes:"%d minutes",hour:"an hour",hours:"%d hours",day:"a day",days:"%d days",month:"a month",months:"%d months",year:"a year",years:"%d years",wordSeparator:" ",numbers:[]},$(function(){$("abbr.timeago").timeago()});