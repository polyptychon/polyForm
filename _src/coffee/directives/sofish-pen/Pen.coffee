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

      options = {
        editor: if isElement then elm[0].querySelector(".pen-panel") else elm[0]
        list: [
          'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'p', 'insertorderedlist', 'insertunorderedlist',
          'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
        ]
        stay: attrs.stay?
      }
      elm.html(attrs.value) if attrs.value? && attrs.pen?
      elm.html(_.escape(elm.html())) if attrs.escape?
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

      # update ngModel
      if isElement
        ngModel.$setViewValue(getContent()) if pen.getContent().length>0 && ngModel?
      else
        ngModel.$setViewValue(getContent()) if attrs.value? && attrs.pen? && ngModel?

      modelChange = false
      pen.on("input", ()->
        modelChange = true
        ngModel.$setViewValue(getContent()) if ngModel?
      )
      if isElement
        scope.$watch(
          () ->
            ngModel.$viewValue
          (newValue, oldValue) ->
            if (newValue != oldValue && !modelChange)
              pen.setContent(newValue)
            modelChange = false
        ) #watch
      # update ngModel end
