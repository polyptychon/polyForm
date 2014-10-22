mapDataToURL = require "../../utils/MapDataToURL.coffee"
formElements = require "../../utils/FormElements.coffee"

module.exports = ($timeout, $http) ->
  restrict: 'A'
  require: ['?ngModel', '^?formControl']
  link: (scope, elm, attrs, ctrls) ->
    ngModel = ctrls[0]
    formControl = ctrls[1]
    timeoutPromise = null
    timeoutDigest = -1
    quietMillis = if (attrs.remoteValidationQuietMillis != null && !isNaN(attrs.remoteValidationQuietMillis)) then attrs.remoteValidationQuietMillis else 500
    name = "remote-validation"

    scope.$watch(
      () ->
        ngModel.$viewValue
      (newValue) ->
        if (newValue != ngModel.$modelValue)
          targetElement.addClass("ng-#{name}-pending")
    ) #watch

    scope.$watch(
      () ->
        ngModel.$modelValue
      (newValue) ->
        clearTimeout(timeoutDigest)
        $timeout.cancel(timeoutPromise)
        targetElement.removeClass("ng-#{name}-error-loading")

        if (!newValue? || newValue.length < 2 || attrs.remoteValidation == "" || attrs.remoteValidation.length < 2)
          targetElement.removeClass("ng-#{name}-loading")
          targetElement.removeClass("ng-loading")
          return

        targetElement.removeClass("ng-#{name}-pending");
        targetElement.addClass("ng-#{name}-loading");
        targetElement.addClass("ng-loading");

        timeoutPromise = $timeout(
          () ->
            url = mapDataToURL(attrs.remoteValidation, attrs.remoteValidationMapData, scope.$parent)
            dataType = attrs.remoteValidationDataType || "json"

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
              ).then(() ->
                onDefault()
              )
            else
              $http (
                method: 'GET'
                url: url
              )
              .success(
                (data) ->
                  onSuccess(data)
              )
              .error(() ->
                onError()
              )
              .then(() ->
                onDefault()
              )

            onSuccess =
              (data) ->
                targetElement.removeClass("ng-#{name}-error-loading")
                return unless (data?)
                $(formControl.element).find(".error-message.remote-validation").html(data) if data!=true
                validatorFn(newValue, data==true)
                update()

            onError =
              () ->
                targetElement.addClass("ng-#{name}-error-loading")
                validatorFn(newValue, true);
                update()

            onDefault =
              () ->
                targetElement.removeClass("ng-#{name}-pending")
                targetElement.removeClass("ng-#{name}-loading")
                targetElement.removeClass("ng-loading")
                update()

            update = () ->
              formControl.copyChildClassesToParent(targetElement) if formControl?

        , quietMillis)
    ) #watch

    validatorFn = (modelValue, value) ->
      normalizedName = attrs.$normalize(name)
      if (value)
        ngModel.$setValidity(normalizedName, true);
      else
        ngModel.$setValidity(normalizedName, false);
      modelValue;

    ngModel.$parsers.unshift(validatorFn);
