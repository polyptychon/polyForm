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
    usePreview = attrs.usePreview? && attrs.usePreview!="false"
    usePreview = true unless attrs.usePreview?

    buttonBar = elm.find(".button-bar")
    input = elm.find("textarea")
    preview = elm.find(".well")

    # resize start
    oldWidth = oldHeight = null
    resize = (w,h)->
      preview.css('width', "#{100-(w/input.parent().outerWidth()*100)}%")
      preview.outerHeight(h)

    mousemove = () ->
      w = input.outerWidth()
      h = input.outerHeight()
      oldWidth  = w unless oldWidth
      oldHeight  = h unless oldHeight
      if w!=oldWidth || h!=oldHeight
        requestAnimFrame(()->
          resize(w,h)
          oldWidth  = w
          oldHeight  = h
        )

    input.bind('mousedown mousemove', (e)->
      $(window).unbind("mousemove", mousemove).bind("mousemove", mousemove)
    )
    $(window).bind("mouseup", ()->
      $(window).unbind("mousemove", mousemove)
      mousemove()
    )
    # resize end

    converter = new pagedown.Converter()
    pagedownExtra.Extra.init(converter, {table_class: "table table-striped table-bordered table-hover"})
    editor = new Editor(converter, null, {}, {buttonBar: buttonBar[0], input: input[0], preview: preview[0]})
    editor.run()

    requestAnimFrame(() ->
      if !usePreview
        preview.css("display", "none")
        input.css('width', '100%')

      preview.outerHeight(input.outerHeight())

      text = elm.text()
      input.val(text)
      editor.refreshPreview()
    )

    getContent = ()->
      input.val()

    setContent = (value)->
      input.val(value)

    # update ngModel
    if ngModel?
      requestAnimFrame(() ->
        ngModel.$setViewValue(getContent())
      )
      modelChange = false

      input.on("input", ()->
        modelChange = true
        ngModel.$setViewValue(getContent())
        ngModel.$render()
      )

      scope.$watch(
        () ->
          ngModel.$viewValue
        (newValue, oldValue) ->
          editor.refreshPreview() unless newValue?
          if (newValue != oldValue && !modelChange)
            requestAnimFrame(()->
              setContent(newValue)
            )

          modelChange = false
      ) #watch
      # update ngModel end

