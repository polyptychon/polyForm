pagedown = require "pagedown"
pagedownExtra = require ("pagedown-extra")
requestAnimFrame = require "animationframe"
Editor = pagedown.Editor
module.exports = () ->
  restrict: 'E'
  template: require "./pagedown.jade"
  replace: true
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
      input.trigger("input") if text.length>0
      editor.refreshPreview()
    )

    getContent = ()->
      input.val()

    setContent = (value)->
      value = "" unless value?
      input.val(value)
      editor.refreshPreview()

    # update ngModel
    if ngModel?
      modelChange = false

      updateModel = (e) ->
        modelChange = true
        ngModel.$setViewValue(getContent())
        ngModel.$render()


      elm.find(".wmd-button").bind("click", updateModel)
      input.bind("input keydown", updateModel)

      scope.$watch(
        () ->
          ngModel.$viewValue
        (newValue, oldValue) ->
          if (newValue != oldValue && !modelChange)
            requestAnimFrame(()->
              setContent(newValue)
            )

          modelChange = false
      ) #watch
      # update ngModel end

