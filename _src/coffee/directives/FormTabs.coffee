$ = require "jquery"

module.exports = ()  ->
  restrict: 'E'
  transclude: true
  scope:
    {
      selectFormTabIndex: '@'
    }

  controller: ($scope, $element, $attrs) ->
    panes = $scope.panes = [];

    $attrs.$observe('selectFormTabIndex', (newValue) ->
      $scope.select(panes[newValue])
    )

    $scope.select = (pane) ->
      $scope.$parent.selectFormTabIndex = $scope.getPaneIndex(pane);
      return if (typeof pane == "undefined")
      angular.forEach(panes, (pane) ->
        pane.selected = false
      )
      pane.disabled = false
      pane.selected = true

    $scope.getPaneIndex = @getPaneIndex = (currentPane) ->
      return -1 if (currentPane == null)
      for pane,index in panes
        if (pane == currentPane)
          return index;
      return -1

    @getNextPane = (pane) ->
      panes[$scope.getPaneIndex(pane) + 1]

    @selectNextPane = (pane) ->
      nextPane = @getNextPane(pane);
      $scope.select(nextPane);

      $scope.$evalAsync(()  ->
        nextPane.setFocus();
      )

    @isLastPane = (pane) ->
      $scope.getPaneIndex(pane) == panes.length - 1 || @getNextPane()

    @addPane = (pane) ->
      @addPaneAt(pane, panes.length)

    @addPaneAt = (pane, index) ->
      $scope.select(pane) if (panes.length == 0)
      panes.splice(index, 0, pane) if ($scope.getPaneIndex(pane) < 0)


    @removePane = (current_pane) ->
      return false if (!pane)

      for pane,index in panes
        if (pane == current_pane)
          current_pane.disabled = true
          panes.splice(index, 1)
          return true

  template:
    '<div class="form-container row">' +
    '<h1>' +
    '<ul id="formTablist" class="breadcrumb" role="tablist">' +
    '<li ng-repeat="pane in panes" ng-class="{active:pane.selected, disabled:pane.disabled }">' +
    '<a href="" ng-click="select(pane)">{{pane.tabTitle}}</a>' +
    '</li>' +
    '</ul>' +
    '</h1>' +
    '<div class="tab-content" ng-transclude></div>' +
    '</div>'

  replace: true
