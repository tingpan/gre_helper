angular.module 'greHelper.controllers'
  .controller 'CardsCtrl', ($scope, $ionicHistory, $timeout, $ionicPlatform, DeckService) ->

    $scope.title = "Cards"
    $scope.data = DeckService.data

    $scope.goBack = ->
      $ionicHistory.goBack()

    $scope.isFlipped = false

    $scope.$watch "isFlipped", ->
      adjHeight()

    $scope.flip = () ->
      $scope.isFlipped = !$scope.isFlipped

    $scope.nextWord = ($event)->
      $event.stopPropagation()
      $scope.isFlipped = false
      $scope.cards = []
      $timeout ->
        $scope.cards = [DeckService.next()]
      , 150

    $scope.newWord = ($event)->
      $event.stopPropagation()
      DeckService.newWord()
      $scope.nextWord($event)

    $scope.colorIndex = (max)->
      return Math.floor(Math.random() * max)

    adjHeight = ->
      $card = $('#my-word-card')
      height = if $scope.isFlipped then $card.find('.face.back').height() else $card.find('.face.front').height()
      $('#placeholder').css('height', height)
      return 0

    DeckService.init([1..20])

    $scope.cards = [DeckService.next()]
