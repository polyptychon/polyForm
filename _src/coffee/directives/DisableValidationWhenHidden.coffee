$ = require "jquery"
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

    controlElements = elm.find(formElements)
    controls = []

    if (formTab?.scope?.disabled?)
      formTab.scope.$watch("disabled", (value) ->
        update(scope.$eval(attrs.ngShow))
      )

    if (attrs.ngShow?)
      scope.$parent.$watch(attrs.ngShow, (value) ->
        update(value)
      )

    if (attrs.ngHide?)
      scope.$parent.$watch(attrs.ngHide, (value) ->
        update(!value)
      )

    update = (value) ->
      controlElements.each(
        (controlElement) ->
          element = $(this);
          control = form[element.attr("name")]

          unless (control?)
            control = controlElement
          else
            controls.push(control)

          return unless (control?)

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
