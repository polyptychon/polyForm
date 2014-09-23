module.exports = () ->
  restrict: 'E'
  transclude: true
  template: '<div class="form-group" ng-transclude></div>'
  replace: true
