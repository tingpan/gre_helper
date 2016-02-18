
routerConfigure = ($stateProvider, $urlRouterProvider) ->

  $stateProvider
  .state 'tab',
    url: '/tab'
    abstract : true
    views:
      'tpl-view':
        templateUrl: 'pages/tabs/template.html'

  .state 'tab.gre-list',
    url: '/list'
    views:
      'tab-list':
        templateUrl: 'pages/tabs/list/template.html'
        controller: 'ListCtrl'

  .state 'tab.gre-challenge',
    url: '/challenge'
    views:
      'tab-challenge':
        templateUrl: 'pages/tabs/challenge/template.html'
        controller: 'ChallengeCtrl'

  .state 'cards',
    url: '/cards'
    views:
      'tpl-view':
        templateUrl: 'pages/cards/template.html'
        controller: 'CardsCtrl'

  $urlRouterProvider.otherwise('/tab/list')


routerConfigure.$inject = ['$stateProvider', '$urlRouterProvider']

angular
.module 'greHelper'
.config routerConfigure

