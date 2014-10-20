mapDataToURL = require "../../utils/MapDataToURL.coffee"
_ = require "lodash"

module.exports = ($timeout, $http) ->
  restrict: 'E'
#  scope:
#    path: '@'
#    variable: '@'
#    quietMillis: '@'
#    mapData: '@'
#    queryDataType: '@'
#    updateOnExpressionChange: '@'
  link: (scope, elm, attrs) ->
    timeoutPromise = null
    minimumInputLength = if (attrs.minimumInputLength? && !isNaN(attrs.minimumInputLength)) then attrs.minimumInputLength else 3
    maximumInputLength = if (attrs.maximumInputLength? && !isNaN(attrs.maximumInputLength)) then attrs.maximumInputLength else null
    quietMillis = if (attrs.quietMillis? && !isNaN(attrs.quietMillis)) then attrs.quietMillis else 500


    attrs.$observe("updateOnExpressionChange", (newValue, oldValue) ->
      return unless (newValue? && newValue != oldValue)
      $timeout.cancel(timeoutPromise)
      timeoutPromise = $timeout(
        () ->
          if (newValue.length >= minimumInputLength && (maximumInputLength == null || newValue.length < maximumInputLength))
            load()
      , quietMillis)
    )
    onSuccess = (response) ->
      elm.parent().removeClass("ng-loading")
      if attrs.variable?
        if attrs.queryResultsArrayPath?
          paths = attrs.queryResultsArrayPath.split(".")
          a = response
          _.forEach(paths, (path) ->
            a = a[path]
          )
          scope[attrs.variable] = a
        else
          scope[attrs.variable] = response


    onError = () ->
      elm.parent().removeClass("ng-loading");
      scope[attrs.variable] = {};

    load = () ->
      scope[attrs.variable] = [] if attrs.variable?
      url = mapDataToURL(attrs.path, attrs.mapData, scope)
      if (!url? || url=="")
        elm.parent().removeClass("ng-loading");
        return
      elm.parent().addClass("ng-loading");
      dataType = attrs.queryDataType || "json"

      if (dataType == "jsonp")
        if (url.indexOf("?") < 0)
          url += "?callback=JSON_CALLBACK"
        else
          if (url.indexOf("callback=JSON_CALLBACK") < 0)
            url = url.replace(/\?/gi, "?callback=JSON_CALLBACK&")

        $http.jsonp(url).success((response) ->
          onSuccess(response)
        ).error(() ->
          onError()
        )
      else
        $http.get(url).success(onSuccess).error(onError)


    load()
