requestAnimFrame = require "animationframe"
module.exports = ($parse) ->
  restrict: 'E'
  link: (scope, element, attrs) ->
    if (attrs.ngModel && attrs.checked)
      requestAnimFrame(() ->
        $parse(attrs.ngModel).assign(scope, attrs.checked)
        element.trigger("change")
      )
    else if (attrs.ngModel && attrs.value)
      requestAnimFrame(() ->
        element.val(attrs.value)
        element.trigger("change")
      )

