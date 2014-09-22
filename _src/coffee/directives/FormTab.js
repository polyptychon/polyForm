// Generated by CoffeeScript 1.7.1
(function() {
  var $;

  $ = require("jquery");

  module.exports = function() {
    return {
      restrict: 'E',
      transclude: true,
      scope: {
        tabTitle: '@',
        nextTabButtonLabel: '@'
      },
      require: ['^form', '^formTabs'],
      link: function(scope, element, attrs, ctrls) {
        var controlElements, controls, form, parentCtrl, removeIndex;
        form = ctrls[0];
        parentCtrl = ctrls[1];
        if (!parentCtrl) {
          return;
        }
        removeIndex = -1;
        controlElements = element.find(formElements);
        controls = [];
        scope.isLastPane = function() {
          return parentCtrl.isLastPane(scope);
        };
        scope.getNextPane = function() {
          return parentCtrl.getNextPane(scope);
        };
        scope.selectNextPane = function() {
          return parentCtrl.selectNextPane(scope);
        };
        return toggleValidation(value)(function() {
          var i;
          i = 0;
          controlElements.each(function() {
            var control;
            element = $(this);
            control = form[element.attr("name")];
            if (!control) {
              control = controls[i];
              i++;
            } else {
              controls.push(control);
            }
            if (!control) {
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
          return togglePane(value)(function() {
            if (value) {
              parentCtrl.addPaneAt(scope, removeIndex);
            } else {
              removeIndex = parentCtrl.getPaneIndex(scope);
              parentCtrl.removePane(scope);
            }
            toggleValidation(value);
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
            return parentCtrl.addPane(scope);
          });
        });
      },
      controller: function($scope, $element) {
        var formControls;
        this.scope = $scope;
        $scope.disabled = true;
        $scope.isPaneInValid = true;
        formControls = $scope.formControls = [];
        $scope.$evalAsync(function() {
          return $($element).find(formElements).bind("keyup input blur change click", function() {
            var nextPane;
            nextPane = $scope.getNextPane();
            if (nextPane) {
              nextPane.enabled = false;
            }
            $scope.isPaneInValid = false;
            $($element).find("input:visible, select:visible, textarea:visible, datalist:visible, [select2]:visible").each(function() {
              if ($(this).hasClass("ng-invalid")) {
                if (nextPane) {
                  nextPane.enabled = true;
                }
                return $scope.isPaneInValid = true;
              }
            });
            return $scope.$digest();
          });
        });
        $scope.setFocus = function() {
          return $scope.$evalAsync(function() {
            return setTimeout(function() {
              return $($element).find(formElements).first().focus();
            }, 200);
          });
        };
        return this.addFormControl = function(formControl) {
          return formControls.push(formControl);
        };
      },
      template: '<div class="tab-pane" ng-class="{ active: selected }">' + '<div ng-transclude></div>' + '<form-control class="col-md-12" ng-hide="isLastPane()">' + '<button type="button" ng-click="selectNextPane()" class="btn btn-primary" ng-disabled="isPaneInValid">{{nextTabButtonLabel}}</button>' + '</form-control>' + '</div>',
      replace: true
    };
  };

}).call(this);

//# sourceMappingURL=FormTab.map
