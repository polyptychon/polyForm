module.exports = () ->
  restrict: 'E'
  transclude: true
  template: '<div class="input-group" ng-transclude></div>'
  replace: true
