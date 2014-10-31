if jQuery then $ = jQuery else $ = require "jquery"
_ = require "lodash"
requestAnimFrame = require "animationframe"
require "pen"

module.exports = () ->
  restrict: 'EA'
  template: require './pen.jade'
  replace: true
  transclude: true
  require: '?ngModel'
  scope: {}
  compile: (tElement, tAttrs) ->
    placeholder = tElement.context.placeholder
    isElement = tElement.context.nodeName == "PEN"

    (scope, elm, attrs, ngModel) ->
      placeholder = attrs.placeholder unless placeholder?
      scope.useEditButton = attrs.useEditButton? && attrs.useEditButton!="false"
      scope.isEditable = !isElement || attrs.isEditable? && attrs.isEditable!="false"

      elm.height(parseInt(attrs.rows)*19) if attrs.rows
      editor = (if isElement then elm[0].querySelector(".pen-panel") else elm[0])
      options = {
        editor: editor
        list: [
          'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'p', 'insertorderedlist', 'insertunorderedlist',
          'indent', 'outdent', 'bold', 'italic', 'underline', 'createlink'
        ]
        stay: attrs.stay?
      }
      $(editor).html(attrs.value) if attrs.value? && attrs.pen?
      $(editor).html(_.escape($(editor).html())) if attrs.escape?

      pen = new Pen(options)
      pen.placeholder(placeholder) if placeholder?

      setEditable = (value) ->
        if (!value)
          elm.removeClass("active")
          pen.destroy()
        else
          elm.addClass("active")
          pen.rebuild()
          if ngModel?
            pen.on("input", onPenInput)

      getContent = ()->
        if attrs.escape?
          _.unescape(pen.getContent())
        else
          _.escape(pen.getContent())

      setContent = (value)->
        pen._placeholder = null
        $(".pen-menu").hide() unless value?
        if attrs.escape?
          pen.setContent(_.escape(value))
        else
          pen.setContent(_.unescape(value))

      requestAnimFrame(()->
        setEditable(scope.isEditable)

        elm.find('#mode').on('click', ()->
          setEditable(!$(@).hasClass('active'))
        )
      )

      # update ngModel
      if ngModel?
        ngModel.$setViewValue(getContent())
        modelChange = false

        onPenInput = ()->
          modelChange = true
          ngModel.$setViewValue(_.unescape(getContent()))
          ngModel.$render()

        pen.on("input", onPenInput)

        scope.$watch(
          () ->
            ngModel.$viewValue
          (newValue, oldValue) ->
            pen.rebuild() unless newValue?
            if (newValue != oldValue && !modelChange)
              requestAnimFrame(()->
                setContent(newValue)
              )

            modelChange = false
        ) #watch
        # update ngModel end
