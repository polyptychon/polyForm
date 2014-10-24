require "pen"

module.exports = () ->
  restrict: 'EA'
  template: require './pen.jade'
  replace: true

  link: (scope, elm, attrs) ->
    options = {
      editor: elm[0]
      debug: true
      textarea: '<textarea name="content"></textarea>'
      list: [
        'blockquote', 'p', 'insertorderedlist', 'insertunorderedlist',
        'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
      ]
      stay: false
    }
    pen = new Pen(options)
    #console.log pen.getContent()


