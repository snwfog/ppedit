#= require Box

class ChangeBoxContentCommand

  constructor: (@box, @prevContent, @newContent) ->

  execute: ->
    @box.element.html(@newContent)

  undo: ->
    @box.element.html(@prevContent)