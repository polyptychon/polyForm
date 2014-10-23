require "pen"

module.exports = () ->
  restrict: 'A'
  link: (scope, elm, attrs) ->
    editor = new Pen(elm)
