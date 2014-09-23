mapDataToURL = require "../utils/MapDataToURL.coffee"

module.exports = ($timeout, $http, $parse) ->
  restrict: 'E'
  scope:
    isUniqueQuietMillis: '@'
    isUniqueMapData: '@'
  link: (scope, elm, attrs) ->
    timeoutPromise = null
    minimumInputLength = if (typeof attrs.minimumInputLength != "undefined" && !isNaN(attrs.minimumInputLength)) then attrs.minimumInputLength else 3
    maximumInputLength = if (typeof attrs.maximumInputLength != "undefined" && !isNaN(attrs.maximumInputLength)) then attrs.maximumInputLength else null
    quietMillis = if (typeof attrs.quietMillis != "undefined" && !isNaN(attrs.quietMillis)) then attrs.quietMillis else 500

    attrs.$observe("updateOnModelChange", (newValue, oldValue) ->
      return if (typeof newValue == "undefined" || newValue == oldValue)
      $timeout.cancel(timeoutPromise)
      timeoutPromise = $timeout(
        () ->
          if (newValue.length >= minimumInputLength && (maximumInputLength == null || newValue.length < maximumInputLength))
            load()
      , quietMillis)
    )

    load = () ->
      url = mapDataToURL(attrs.path, attrs.mapData, scope)
      if (typeof url=="undefined" || url=="")
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

        $http.jsonp(url).success(onSuccess).error(onError)
      else
        $http.get(url).success(onSuccess).error(onError)

      onSuccess = (response) ->
        elm.parent().removeClass("ng-loading")
        scope[attrs.variable] = response


      onError = () ->
        elm.parent().removeClass("ng-loading");
        scope[attrs.variable] = {};


