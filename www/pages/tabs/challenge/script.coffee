angular.module 'greHelper.controllers'
  .controller 'ChallengeCtrl', ($scope, $state) ->
    $scope.title = "My Challenge"
    $scope.goCards = ->
      $state.go 'cards',
        list: JSON.stringify
          name : "All Words"

