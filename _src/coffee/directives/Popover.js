// Generated by CoffeeScript 1.7.1
(function() {
  var $, formElements;

  $ = require("jquery");

  formElements = require("../utils/FormElements.coffee");

  module.exports = function() {
    return {
      restrict: 'E',
      transclude: true,
      template: '<div class="popover" role="tooltip"> <div class="arrow"></div> <h3 class="popover-title"></h3> <div class="popover-content" ng-transclude></div> </div>',
      replace: false,
      scope: {
        preventCloseOnPopOverClick: '@',
        title: '@',
        animation: '@',
        container: '@',
        placement: '@',
        delay: '@',
        trigger: '@',
        viewport: '@'
      },
      link: function(scope, elm, attrs) {
        var cancelPopOverClose, content, formControl, title;
        elm.hide();
        formControl = elm.parent().find(formElements).first();
        if (attrs.selector) {
          formControl = $(attrs.selector);
        }
        content = elm.find("[ng-transclude]");
        title = (content.find("h3").length > 0 ? content.find("h3").remove().text() : null);
        content = content.html();
        formControl.popover({
          animation: attrs.animation === "true" || false,
          container: attrs.container || null,
          placement: attrs.placement || "top",
          delay: (attrs.delay && isNaN(parseInt(attrs.delay)) ? parseInt(attrs.delay) : 0),
          trigger: attrs.trigger || "focus",
          viewport: attrs.viewport || {
            selector: 'body',
            padding: 0
          },
          title: title,
          content: content,
          html: true,
          template: elm.html()
        });
        if (attrs.preventCloseOnPopOverClick === "true") {
          formControl.bind(attrs.trigger || "focus", function() {
            formControl.parent().find(".popover").bind("mousedown", function() {
              return formControl.bind("hide.bs.popover", cancelPopOverClose);
            });
            return formControl.parent().find(".popover").bind("click", function() {
              formControl.unbind("hide.bs.popover", cancelPopOverClose);
              return formControl.focus();
            });
          });
        }
        return cancelPopOverClose = function(e) {
          return e.preventDefault();
        };
      }
    };
  };

}).call(this);

//# sourceMappingURL=Popover.map
