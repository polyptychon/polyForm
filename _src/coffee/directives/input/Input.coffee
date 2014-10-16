requestAnimFrame = require "animationframe"
module.exports = ($parse) ->
  restrict: 'E'
  link: (scope, element, attrs) ->
    if (attrs.ngModel && attrs.value)
      requestAnimFrame(() ->
        element.val(attrs.value)
        element.trigger("change")
      )

