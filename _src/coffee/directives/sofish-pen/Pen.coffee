require "pen"

module.exports = () ->
  restrict: 'EA'
  template: require './pen.jade'
  replace: true
  require: '?ngModel'
  link: (scope, elm, attrs, ngModel) ->
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

    elm.html(elm.attr("value")) if elm.attr("value")?
    pen = new Pen(options)
    ngModel.$setViewValue(pen.getContent()) if elm.attr("value")?

    pen.on("input", ()->
      ngModel.$setViewValue(pen.getContent())
    )


