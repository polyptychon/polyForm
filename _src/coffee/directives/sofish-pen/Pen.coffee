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
      elm.height(parseInt(attrs.rows)*19) if attrs.rows
      options = {
        editor: elm[0]
        debug: false
        textarea: '<textarea name="content"></textarea>'
        list: [
          'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'p', 'insertorderedlist', 'insertunorderedlist',
          'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
        ]
        stay: false
      }

      elm.html(attrs.value) if attrs.value? && attrs.pen?
      pen = new Pen(options)

      if isElement
        ngModel.$setViewValue(pen.getContent()) if pen.getContent().length>0 && ngModel?
      else
        ngModel.$setViewValue(pen.getContent()) if attrs.value? && attrs.pen? && ngModel?

      pen.placeholder(placeholder) if placeholder?
      pen.on("input", ()->
        ngModel.$setViewValue(pen.getContent()) if ngModel?
      )
