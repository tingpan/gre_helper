angular.module 'greHelper.controllers'
  .controller 'ListCtrl', ($scope,ListService) ->
    $scope.title = "My List"
    $scope.lists = ListService.list

