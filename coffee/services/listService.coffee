angular.module('greHelper.services').factory 'ListService', (StorageService) ->
  lists = [
    {
      name: "List 1"
      fid: 1
      tid: 82
    },
    {
      name: "List 2"
      fid: 83
      tid: 120
    }
  ]

  init = ->
    for list in lists
      StorageService.update 'list', list


  init : init
  list : lists
