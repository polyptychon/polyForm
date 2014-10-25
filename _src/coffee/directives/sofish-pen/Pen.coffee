_ = require "lodash"
$ = require "jquery"
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
        debug: false
        textarea: '<textarea name="content"></textarea>'
        list: [
          'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'p', 'insertorderedlist', 'insertunorderedlist',
          'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
        ]
        stay: false
      }
      elm.html(attrs.value) if attrs.value? && attrs.pen?
      elm.html(_.escape(elm.html())) if attrs.escape?
      pen = new Pen(options)

      elm.find('#mode').on('click', ()->
        if($(@).hasClass('active'))
          pen.destroy()
        else
          pen.rebuild()
      )

      getContent = ()->
        text = ""
        if attrs.escape?
          _.unescape(pen.getContent())
        else
          _.escape(pen.getContent())

      if isElement
        ngModel.$setViewValue(getContent()) if pen.getContent().length>0 && ngModel?
      else
        ngModel.$setViewValue(getContent()) if attrs.value? && attrs.pen? && ngModel?

      modelChange = false
      pen.placeholder(placeholder) if placeholder?
      pen.on("input", ()->
        modelChange = true
        ngModel.$setViewValue(getContent()) if ngModel?
      )

      scope.$watch(
        () ->
          ngModel.$viewValue
        (newValue, oldValue) ->
          if (newValue != oldValue && !modelChange)
            pen.setContent(newValue)
          modelChange = false
      ) #watch
