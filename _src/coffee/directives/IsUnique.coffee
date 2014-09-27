mapDataToURL = require "../utils/MapDataToURL.coffee"

module.exports = ($timeout, $http) ->
  restrict: 'A'
  require: '?ngModel'
  scope:
    isUniqueQuietMillis: '@'
    isUniqueMapData: '@'
  link: (scope, elm, attrs, ngModel) ->
    timeoutPromise = null
    timeoutDigest = -1
    quietMillis = if (attrs.isUniqueQuietMillis != null && !isNaN(attrs.isUniqueQuietMillis)) then attrs.quietMillis else 500

    scope.$watch(
      () ->
        ngModel.$viewValue
      (newValue) ->
        if (newValue != ngModel.$modelValue)
          elm.addClass("ng-is-unique-pending")
    ) #watch

    scope.$watch(
      () ->
        ngModel.$modelValue
      (newValue) ->
        clearTimeout(timeoutDigest)
        $timeout.cancel(timeoutPromise)
        elm.removeClass("ng-is-unique-error-loading")

        if (typeof newValue == "undefined" || newValue.length < 2 || attrs.isUnique == "" || attrs.isUnique.length < 2)
          elm.removeClass("ng-is-unique-loading")
          elm.removeClass("ng-loading")
          return

        elm.removeClass("ng-is-unique-pending");
        elm.addClass("ng-is-unique-loading");
        elm.addClass("ng-loading");

        timeoutPromise = $timeout(
          () ->
            url = mapDataToURL(attrs.isUnique, attrs.isUniqueMapData, scope.$parent)
            $http (
              method: 'GET'
              url: url
            )
            .success(
              (data) ->
                elm.removeClass("ng-is-unique-error-loading")
                return if (data.isUnique == null)
                validatorFn(newValue, data.isUnique == "true")
                update()
            )
            .error(
              () ->
                elm.addClass("ng-is-unique-error-loading")
                validatorFn(newValue, true);
                update()
            )
            .then(
              () ->
                elm.removeClass("ng-is-unique-pending")
                elm.removeClass("ng-is-unique-loading")
                elm.removeClass("ng-loading")
                update()
            )
            update = () ->
              timeoutDigest = setTimeout(
                () ->
                  elm.trigger("keyup")
              , 100)

        , quietMillis - 100)
    ) #watch

    validatorFn = (modelValue, value) ->
      if (value)
        ngModel.$setValidity('isUnique', true);
      else
        ngModel.$setValidity('isUnique', false);
      modelValue;

    ngModel.$parsers.unshift(validatorFn);
