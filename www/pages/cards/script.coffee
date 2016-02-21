angular.module 'greHelper.controllers'
  .controller 'CardsCtrl', ($scope, $ionicHistory, $timeout, $ionicPlatform, DeckService, $stateParams) ->

    $scope.goBack = ->
      $ionicHistory.goBack()

    $scope.isFlipped = false


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

    $ionicPlatform.ready ->
      $scope.list = JSON.parse($stateParams.list)
      $scope.title = $scope.list.name
      $scope.data = DeckService.data
      from = $scope.list.fid || 1
      to = $scope.list.tid || Object.keys(wordDB).length
      DeckService.init([from..to])
      $scope.cards = [DeckService.next()]
      $scope.$watch "isFlipped", ->
        adjHeight()


