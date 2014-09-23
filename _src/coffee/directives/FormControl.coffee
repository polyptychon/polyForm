$ = require "jquery"
formElements = require "../utils/FormElements.coffee"
requestAnimFrame = require "animationframe"

module.exports = () ->
  restrict: 'E'
  transclude: true
  template: '<div class="has-feedback ng-transclude"></div>'
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
        scope.copyChildClassesToParent(@) if (newValue != null)
      )
    )

    controlElements.on("keyup input blur change click", () ->
      scope.copyChildClassesToParent($(@))
    )

  controller: ($scope, $element) ->
    element = $element;

    $scope.copyChildClassesToParent = @copyChildClassesToParent = (childElement, updateOnNextFrame) ->
      return if (childElement == null || typeof childElement.length == "undefined" || childElement.attr('class') == null)

      attrClasses = $(element).attr("class").replace(/ng-(\w|\-)+\s?/gi, "")
      attrClasses = attrClasses.replace(/\s?has-success|has-error\s?/gi, "")
      attrClasses = attrClasses.replace(/\s\s/gi, "")
      inputClasses = ""
      isValid = (childElement.hasClass("ng-valid"))
      inputClasses += childElement.attr("class").toString().match(/ng-(\w|\-)+\s?/gi).join(" ")

      if (isValid)
        attrClasses += " has-success"
      else if (childElement.hasClass("ng-invalid") && !childElement.hasClass("ng-pristine"))
        attrClasses += " has-error"

      if (element.find('.select2-allowclear').length > 0)
        if (attrClasses.indexOf("select-clear") < 0)
          attrClasses += " select-clear "
        else
          attrClasses = attrClasses.replace(/select-clear/gi, "")

      attrClasses = attrClasses.replace(/ng-\w+-?\w+\s/gi, "")
      $(element).attr("class", attrClasses + " " + inputClasses)

      if (updateOnNextFrame != null)
        requestAnimFrame ( () ->
          $scope.copyChildClassesToParent(childElement, false)
        )