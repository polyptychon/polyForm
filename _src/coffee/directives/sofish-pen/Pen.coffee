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
        'blockquote', 'p', 'insertorderedlist', 'insertunorderedlist',
        'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
      ]
      stay: false
    }
    pen = new Pen(options)

    #console.log ngModel
    #console.log elm.attr("value")
    #console.log pen.getContent()


