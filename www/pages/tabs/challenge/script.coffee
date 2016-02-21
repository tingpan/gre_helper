angular.module 'greHelper.controllers'
  .controller 'ChallengeCtrl', ($scope) ->
    $scope.title = "My Challenge"
    $scope.goCards = ->
      list:
        name : "All Words"
