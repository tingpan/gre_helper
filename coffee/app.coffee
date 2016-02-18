angular.module 'greHelper.controllers', []
angular.module 'greHelper.services', []
angular.module 'greHelper.directives', []


angular.module('greHelper', ['ionic','ngCordova', 'greHelper.controllers','greHelper.services','greHelper.directives'])

.run ($ionicPlatform, $cordovaSQLite, $rootScope, $log, StorageService) ->
  $ionicPlatform.ready ->
    if window.cordova && window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
      cordova.plugins.Keyboard.disableScroll true

    if window.StatusBar
      StatusBar.st

    if (window.cordova && window.SQLitePlugin)
      $rootScope.db = $cordovaSQLite.openDB('gre-helper.db', 1)
      $log.debug "open sqlite db"
    else
      $rootScope.db = window.openDatabase('gre-helper', '1.0', 'my.db', 1024 * 1024)
      $log.debug "open window db"

    StorageService.initDb()

