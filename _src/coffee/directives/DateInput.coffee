module.exports = () ->
  restrict: 'E'
  transclude: true
  template:
    '<div class="input-group date">
      <span class="input-group-addon"><i class="glyphicon glyphicon-th"></i></span>
      <div ng-transclude></div>
     </div>'
  replace: true

  link: (scope, element, attrs) ->
    rangeInputs = null
    if (attrs.bindInputs)
      t = attrs.bindInputs.split(",")
      if (t.length>0)
        rangeInputs = []
        angular.forEach(t, (value) ->
          rangeInputs.push($(value))
        )

    element.datepicker(
      {
        multidate: attrs.multidate? attrs.multidate == true: false
        forceParse: attrs.forceParse? attrs.forceParse == true: true
        clearBtn: attrs.clearBtn? attrs.clearBtn == true: false
        todayHighlight: attrs.todayHighlight? attrs.todayHighlight == true: true
        autoclose: attrs.autoclose? attrs.autoclose == true: true
        multidateSeparator: attrs.multidateSeparator || ","
        format: attrs.format || 'dd/mm/yyyy'
        language: attrs.language || "el"
        inputs: rangeInputs
      }
    )
