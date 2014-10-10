$ = require "jquery"
formElements = require "../../utils/FormElements.coffee"
requestAnimFrame = require "animationframe"

module.exports = () ->
  restrict: 'E'
  transclude: true
  template: require './form-control.jade'
  replace: true
  require: ['^form']
  scope:
    type: '@'
  link: (scope, element, attrs, ctrls) ->
    form = ctrls[0]
    controlElements = element.find(formElements)

    element.addClass("select") if (element.find('select, [ui-select2]').length > 0)
    element.addClass("select-multiple") if (element.find('[multiple], [ng-multiple]').length > 0)

    attrs.$observe("type", (value) ->
      scope.type = element.addClass((value || "form-group"))
    )

    element.find('[ng-model]').each(() ->
      childScope = angular.element(this).scope();
      model = $(@).attr("ng-model");
      childScope.$watch(model, (newValue) =>
        scope.copyChildClassesToParent(@) if (newValue?)
      )
    )

    controlElements.on("keyup input blur change click focus select2-opening", (e) ->
      scope.copyChildClassesToParent($(@))
    )

  controller:
    [
      '$scope'
      '$element'
      ($scope, $element) ->
        element = $element;

        $scope.copyChildClassesToParent = @copyChildClassesToParent = (childElement, updateOnNextFrame) ->
          return unless (childElement?)
          childElement = $(childElement)
          select2DropActive = $(".select2-drop-active")
          attrClasses = $(element).attr("class").replace(/ng-(\w|\-)+\s?/gi, "")
          attrClasses = attrClasses.replace(/\s?has-success|has-error\s?/gi, "")
          attrClasses = attrClasses.replace(/\s\s/gi, "")
          inputClasses = ""
          inputClasses += childElement.attr("class").toString().match(/ng-(\w|\-)+\s?/gi).join(" ")

          select2DropActive.removeClass("has-success") if (select2DropActive.hasClass("has-success"))
          select2DropActive.removeClass("has-error") if (select2DropActive.hasClass("has-error"))

          if (childElement.hasClass("ng-valid"))
            attrClasses += " has-success"
            select2DropActive.addClass("has-success")
          else if (childElement.hasClass("ng-invalid") && childElement.hasClass("ng-dirty"))
            attrClasses += " has-error"
            select2DropActive.addClass("has-error")

          if (element.find('.select2-allowclear').length > 0)
            if (attrClasses.indexOf("select-clear") < 0)
              attrClasses += " select-clear "
          else
            attrClasses = attrClasses.replace(/select-clear/gi, "")

          attrClasses = attrClasses.replace(/ng-\w+-?\w+\s/gi, "")
          $(element).attr("class", attrClasses + " " + inputClasses)

          unless (updateOnNextFrame?)
            requestAnimFrame ( () ->
              $scope.copyChildClassesToParent(childElement, false)
            )
    ]