// Generated by CoffeeScript 1.7.1
(function() {
  var $, formElements, requestAnimFrame;

  $ = require("jquery");

  formElements = require("../../utils/FormElements.coffee");

  requestAnimFrame = require("animationframe");

  module.exports = function() {
    return {
      restrict: 'E',
      transclude: true,
      scope: {
        tabTitle: '@',
        nextTabButtonLabel: '@',
        showNextButton: '@'
      },
      template: require('./form-tab.jade'),
      replace: true,
      require: ['^form', '^formTabs'],
      link: function(scope, element, attrs, ctrls) {
        var controlElements, controls, form, formTabs, removeIndex, togglePane, toggleValidation;
        form = ctrls[0];
        formTabs = ctrls[1];
        if (formTabs === null) {
          return;
        }
        removeIndex = -1;
        controlElements = element.find(formElements);
        controls = [];
        scope.showNextButton = true;
        if (attrs.ngShow) {
          scope.$parent.$watch(attrs.ngShow, function(value) {
            return togglePane(value);
          });
        }
        if (attrs.ngHide) {
          scope.$parent.$watch(attrs.ngHide, function(value) {
            return togglePane(!value);
          });
        }
        attrs.$observe("tabTitle", function(value) {
          if (!(value != null)) {
            return scope.tabTitle = "Title";
          }
        });
        attrs.$observe("nextTabButtonLabel", function(value) {
          if (!(value != null)) {
            return scope.nextTabButtonLabel = "Next";
          }
        });
        attrs.$observe("showNextButton", function(value) {
          return scope.showNextButton = (value === "false" ? false : true);
        });
        formTabs.addPane(scope);
        scope.isLastPane = function() {
          return formTabs.isLastPane(scope);
        };
        scope.getNextPane = function() {
          return formTabs.getNextPane(scope);
        };
        scope.selectNextPane = function() {
          return formTabs.selectNextPane(scope);
        };
        toggleValidation = function(value) {
          var i;
          i = 0;
          return controlElements.each(function() {
            var control;
            element = $(this);
            control = form[element.attr("name")];
            if (control === null) {
              control = controls[i];
              i++;
            } else {
              controls.push(control);
            }
            if (!(control != null)) {
              return;
            }
            if (value === true) {
              $(element).removeAttr('disabled');
              form.$addControl(control);
              return angular.forEach(control.$error, function(validity, validationToken) {
                return form.$setValidity(validationToken, !validity, control);
              });
            } else {
              $(element).attr('disabled', 'disabled');
              return form.$removeControl(control);
            }
          });
        };
        return togglePane = function(value) {
          if (value) {
            formTabs.addPaneAt(scope, removeIndex);
          } else {
            removeIndex = formTabs.getPaneIndex(scope);
            formTabs.removePane(scope);
          }
          return toggleValidation(value);
        };
      },
      controller: [
        '$scope', '$element', function($scope, $element) {
          var formControls, isPaneValid;
          $scope.disabled = true;
          $scope.isPaneInValid = true;
          formControls = $scope.formControls = [];
          isPaneValid = function() {
            var enabledElements, nextPane;
            nextPane = $scope.getNextPane();
            $scope.isPaneInValid = false;
            enabledElements = formElements.split(", ").join(":enabled, ") + ":enabled";
            $($element).find(enabledElements).each(function() {
              if ($(this).hasClass("ng-invalid")) {
                return $scope.isPaneInValid = true;
              }
            });
            if (nextPane) {
              nextPane.disabled = $scope.isPaneInValid;
            }
            $scope.$apply();
            return $scope.isPaneInValid;
          };
          $scope.$evalAsync(function() {
            requestAnimFrame((function() {
              return isPaneValid();
            }));
            return $($element).find(formElements).bind("keyup input blur change click", function() {
              return requestAnimFrame((function() {
                return isPaneValid();
              }));
            });
          });
          $scope.setFocus = function() {
            return requestAnimFrame((function() {
              return $($element).find(formElements).first().focus();
            }));
          };
          return this.addFormControl = function(formControl) {
            return formControls.push(formControl);
          };
        }
      ]
    };
  };

}).call(this);

//# sourceMappingURL=FormTab.map
