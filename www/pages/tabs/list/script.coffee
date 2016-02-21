angular.module 'greHelper.controllers'
  .controller 'ListCtrl', ($scope, ListService, $state) ->
    $scope.title = "My List"
    $scope.lists = ListService.list
    $scope.goCards =  (list) ->
      $state.go 'cards',
        list: JSON.stringify list


