angular.module('greHelper.services').factory 'DeckService', () ->

  d =
    deck : []
    used : []

  init = (cards) ->
    d.deck = cards
    flush()

  flush = ->
    for card, i in d.deck
      total = d.deck.length - i - 1
      return if total == 0
      swap = Math.floor(Math.random() * total) + 1 + i
      tmp = card
      d.deck[i] = d.deck[swap]
      d.deck[swap] = tmp

  removeAt = (i) ->
    if i > -1
      d.deck.splice i, 1

  insertAt = (i, v) ->
    if i > -1
      d.deck.splice i, 0, v

  isEmpty = ->
    d.deck.length <= 0

  next = ->
    word = null
    if !isEmpty()
      word = wordDB[d.deck[0]]
      d.used.push(d.deck[0])
      removeAt(0)
    else
      d.deck = d.used
      d.used = []
      flush()
      word =
        prize: true
        p: "./img/prize/#{Math.floor(Math.random() * 36) + 2}.pic.jpg"
        d: "喵喵喵喵喵喵喵喵,看了这么多单词了,就准许你看一眼朕吧!"
    word

  newWord = ->
    d.deck.push(d.used[d.used.length - 1])
    d.used.splice(-1, 1)

  init: init
  next: next
  newWord: newWord
  data: d
