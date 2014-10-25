_ = require "lodash"
$ = require "jquery"
requestAnimFrame = require "animationframe"
require "pen"

module.exports = () ->
  restrict: 'EA'
  template: require './pen.jade'
  replace: true
  transclude: true
  require: '?ngModel'
  compile: (tElement, tAttrs) ->
    placeholder = tElement.context.placeholder
    isElement = tElement.context.nodeName == "PEN"
    (scope, elm, attrs, ngModel) ->
      scope.useEditButton = attrs.useEditButton?
      elm.height(parseInt(attrs.rows)*19) if attrs.rows
      editor = (if isElement then elm[0].querySelector(".pen-panel") else elm[0])
      options = {
        editor: editor
        list: [
          'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'p', 'insertorderedlist', 'insertunorderedlist',
          'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
        ]
        stay: attrs.stay?
      }
      $(editor).html(attrs.value) if attrs.value? && attrs.pen?
      $(editor).html(_.escape($(editor).html())) if attrs.escape?
      elm.addClass("active")

      pen = new Pen(options)
      pen.placeholder(placeholder) if placeholder?

      requestAnimFrame(()->
        elm.find('#mode').on('click', ()->
          if($(@).hasClass('active'))
            elm.removeClass("active")
            pen.destroy()
          else
            elm.addClass("active")
            pen.rebuild()
        )
      )

      getContent = ()->
        if attrs.escape?
          _.unescape(pen.getContent())
        else
          _.escape(pen.getContent())

      setContent = (value)->
        if attrs.escape?
          pen.setContent(_.escape(value))
        else
          pen.setContent(_.unescape(value))

      # update ngModel
      if isElement
        ngModel.$setViewValue(getContent()) if pen.getContent().length>0 && ngModel?
      else
        ngModel.$setViewValue(getContent()) if attrs.value? && attrs.pen? && ngModel?

      modelChange = false
      pen.on("input", ()->
        modelChange = true
        ngModel.$setViewValue(getContent()) if ngModel?
        ngModel.$render()
      )
      if isElement
        scope.$watch(
          () ->
            ngModel.$viewValue
          (newValue, oldValue) ->
            if (newValue != oldValue && !modelChange)
              setContent(newValue)
            modelChange = false
        ) #watch
      # update ngModel end
