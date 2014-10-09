module.exports = () ->
  restrict: 'E'
  transclude: true
  template: '<div class="error-message" ng-transclude></div>'
  replace: true
