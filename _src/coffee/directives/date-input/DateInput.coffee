module.exports = () ->
  restrict: 'E'
  transclude: true
  template: require './date-input.jade'
  replace: true

  link: (scope, element, attrs) ->
    rangeInputs = null
    if (attrs.bindInputs)
      t = attrs.bindInputs.split(",")
      if (t.length > 0)
        rangeInputs = []
        angular.forEach(t, (value) ->
          rangeInputs.push($(value))
        )

    element.datepicker (
      multidate: (if (attrs.multidate) then attrs.multidate == "true" else false)
      forceParse: (if attrs.forceParse then attrs.forceParse == "true" else true)
      clearBtn: (if attrs.clearBtn then attrs.clearBtn == "true" else false)
      todayHighlight: (if attrs.todayHighlight then attrs.todayHighlight == "true" else true)
      autoclose: (if attrs.autoclose then attrs.autoclose == "true" else true)
      multidateSeparator: attrs.multidateSeparator || ","
      format: attrs.format || 'dd/mm/yyyy'
      language: attrs.language || "el"
      inputs: rangeInputs
    )
