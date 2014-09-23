// Generated by CoffeeScript 1.7.1
(function() {
  var $, formElements, requestAnimFrame;

  $ = require("jquery");

  formElements = require("../utils/FormElements.coffee");

  requestAnimFrame = require("animationframe");

  module.exports = function() {
    return {
      restrict: 'E',
      transclude: true,
      template: '<div class="has-feedback ng-transclude"></div>',
      replace: true,
      require: ['^form'],
      scope: {
        type: '@'
      },
      link: function(scope, element, attrs, ctrls) {
        var controlElements, form;
        form = ctrls[0];
        controlElements = element.find(formElements);
        if (element.find('select, [ui-select2]').length > 0) {
          element.addClass("select");
        }
        if (element.find('[multiple], [ng-multiple]').length > 0) {
          element.addClass("select-multiple");
        }
        attrs.$observe("type", function(value) {
          return scope.type = element.addClass(value || "form-group");
        });
        element.find('[ng-model]').each(function() {
          var childScope, model;
          childScope = angular.element(this).scope();
          model = $(this).attr("ng-model");
          return childScope.$watch(model, (function(_this) {
            return function(newValue) {
              if (newValue !== null) {
                return scope.copyChildClassesToParent(_this);
              }
            };
          })(this));
        });
        return controlElements.on("keyup input blur change click", function() {
          return scope.copyChildClassesToParent($(this));
        });
      },
      controller: function($scope, $element) {
        var element;
        element = $element;
        return $scope.copyChildClassesToParent = this.copyChildClassesToParent = function(childElement, updateOnNextFrame) {
          var attrClasses, inputClasses, isValid;
          if (childElement === null || typeof childElement.length === "undefined" || childElement.attr('class') === null) {
            return;
          }
          attrClasses = $(element).attr("class").replace(/ng-(\w|\-)+\s?/gi, "");
          attrClasses = attrClasses.replace(/\s?has-success|has-error\s?/gi, "");
          attrClasses = attrClasses.replace(/\s\s/gi, "");
          inputClasses = "";
          isValid = childElement.hasClass("ng-valid");
          inputClasses += childElement.attr("class").toString().match(/ng-(\w|\-)+\s?/gi).join(" ");
          if (isValid) {
            attrClasses += " has-success";
          } else if (childElement.hasClass("ng-invalid") && !childElement.hasClass("ng-pristine")) {
            attrClasses += " has-error";
          }
          if (element.find('.select2-allowclear').length > 0) {
            if (attrClasses.indexOf("select-clear") < 0) {
              attrClasses += " select-clear ";
            } else {
              attrClasses = attrClasses.replace(/select-clear/gi, "");
            }
          }
          attrClasses = attrClasses.replace(/ng-\w+-?\w+\s/gi, "");
          $(element).attr("class", attrClasses + " " + inputClasses);
          if (updateOnNextFrame !== null) {
            return requestAnimFrame((function() {
              return $scope.copyChildClassesToParent(childElement, false);
            }));
          }
        };
      }
    };
  };

}).call(this);

//# sourceMappingURL=FormControl.map
