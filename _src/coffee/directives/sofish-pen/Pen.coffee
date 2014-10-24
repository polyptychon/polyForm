require "pen"

module.exports = () ->
  restrict: 'EA'
  template: require './pen.jade'
  replace: true
  transclude: true
  require: '?ngModel'

  link: (scope, elm, attrs, ngModel, transclude) ->
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
    transclude

    elm.html(attrs.value) if attrs.value? && attrs.pen?
    pen = new Pen(options)
    ngModel.$setViewValue(pen.getContent()) if attrs.value? && attrs.pen? && ngModel?

    pen.on("input", ()->
      ngModel.$setViewValue(pen.getContent()) if ngModel?
    )
