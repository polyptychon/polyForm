pagedown = require "pagedown"
pagedownExtra = require ("pagedown-extra")
Editor = require "./Markdown.Editor"
requestAnimFrame = require "animationframe"

module.exports = () ->
  restrict: 'E'
  template: require "./pagedown.jade"
  replace: false
  transclude: true
  require: '?ngModel'
  scope: {}
  link: (scope, elm, attrs, ngModel, tranclude) ->
    converter = new pagedown.Converter()
    pagedownExtra.Extra.init(converter)
    buttonBar = elm.find(".button-bar")
    input = elm.find("textarea")
    preview = elm.find(".well")

    editor = new Editor(converter, null, {}, {buttonBar: buttonBar[0], input: input[0], preview: preview[0]})
    editor.run()
    requestAnimFrame(() ->
      preview.outerHeight(input.outerHeight())
    )

