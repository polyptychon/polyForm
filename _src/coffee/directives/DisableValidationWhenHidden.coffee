formElements = require "../utils/FormElements.coffee"

module.exports = () ->
  restrict: 'A'
  require: ['^form', '?^formTab']
  scope:
    isUniqueQuietMillis: '@'
    isUniqueMapData: '@'
  link: (scope, elm, attrs, ctrls) ->
    form = ctrls[0]
    formTab = ctrls[1]

    controlElements = element.find(formElements)
    controls = []

    if (typeof formTab != "undefined" && typeof formTab.scope.disabled != "undefined")
      formTab.scope.$watch("disabled", (value) ->
        update(scope.$eval(attrs.ngShow))
      )
    if (typeof attrs.ngShow != "undefined")
      scope.$watch(attrs.ngShow, (value) ->
        update(value)
      )
    if (typeof attrs.ngHide != "undefined")
      scope.$watch(attrs.ngHide, (value) ->
        update(!value)
      )

    update = (value) ->
      i = 0
      controlElements.each(
        () ->
          element = $(this);
          control = form[element.attr("name")]

          if (typeof control == "undefined")
            control = controls[i]
            i++
          else
            controls.push(control)

          return if (typeof control == "undefined")

          if (value == true)
            $(element).removeAttr('disabled')
            form.$addControl(control)
            angular.forEach(control.$error, (validity, validationToken) ->
              form.$setValidity(validationToken, !validity, control)
            )
          else
            $(element).attr('disabled', 'disabled')
            form.$removeControl(control)
      )
