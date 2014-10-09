$ = require "jquery"
formElements = require "../../utils/FormElements.coffee"

module.exports = () ->
  restrict: 'E'
  transclude: true
  scope:
    tabTitle: '@'
    nextTabButtonLabel: '@'
    showNextButton: '@'
  template:
    '<div class="tab-pane" ng-class="{ active: selected }">
      <div ng-transclude></div>
      <form-control class="col-md-12" ng-hide="isLastPane()">
        <button type="button" ng-click="selectNextPane()" class="btn btn-primary" ng-disabled="isPaneInValid" ng-show="showNextButton">
          {{ nextTabButtonLabel }}
        </button>
      </form-control>
    </div>'
  replace: true
  require: ['^form', '^formTabs']

  link: (scope, element, attrs, ctrls) ->
    form = ctrls[0];
    formTabs = ctrls[1];
    return if (formTabs == null)

    removeIndex = -1
    controlElements = element.find(formElements)
    controls = []

    scope.showNextButton = true

    if (attrs.ngShow)
      scope.$parent.$watch(attrs.ngShow, (value) ->
        togglePane(value)
      )

    if (attrs.ngHide)
      scope.$parent.$watch(attrs.ngHide, (value) ->
        togglePane(!value)
      )
    attrs.$observe("tabTitle", (value) ->
      scope.tabTitle = "Title" unless (value?)
    )

    attrs.$observe("nextTabButtonLabel", (value) ->
      scope.nextTabButtonLabel = "Next" unless (value?)
    )

    attrs.$observe("showNextButton", (value) ->
      scope.showNextButton = (if value=="false" then false else true )
    )

    formTabs.addPane(scope);

    scope.isLastPane = () ->
      formTabs.isLastPane(scope)

    scope.getNextPane = () ->
      formTabs.getNextPane(scope)

    scope.selectNextPane = () ->
      formTabs.selectNextPane(scope)

    toggleValidation = (value) ->
      i = 0;
      controlElements.each(() ->
        element = $(@);
        control = form[element.attr("name")];
        if (control == null)
          control = controls[i]
          i++
        else
          controls.push(control)

        return if (!control)

        if (value == true)
          $(element).removeAttr('disabled');
          form.$addControl(control);
          angular.forEach(control.$error, (validity, validationToken) ->
            form.$setValidity(validationToken, !validity, control)
          )
        else
          $(element).attr('disabled', 'disabled')
          form.$removeControl(control)
      )

    togglePane = (value) ->
      if (value)
        formTabs.addPaneAt(scope, removeIndex)
      else
        removeIndex = formTabs.getPaneIndex(scope)
        formTabs.removePane(scope)

      toggleValidation(value)

  controller: ($scope, $element) ->
    $scope.disabled = true
    $scope.isPaneInValid = true

    formControls = $scope.formControls = []
    $scope.$evalAsync(() ->
      $($element).find(formElements).bind("keyup input blur change click", () ->
        nextPane = $scope.getNextPane()
        nextPane.enabled = false if (nextPane)
        $scope.isPaneInValid = false;
        $($element).find("input:visible, select:visible, textarea:visible, datalist:visible, [select2]:visible").each(() ->
          if ($(@).hasClass("ng-invalid"))
            nextPane.enabled = true if (nextPane)
            $scope.isPaneInValid = true
        )
        $scope.$digest();
      )
    )

    $scope.setFocus = () ->
      $scope.$evalAsync(() ->
        setTimeout(() ->
          $($element).find(formElements).first().focus()
        , 200)
      )

    @addFormControl = (formControl) ->
      formControls.push(formControl)
