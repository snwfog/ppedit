#= require Box

class MoveBoxCommand

  constructor: (@box, @toPosition, @fromPosition) ->
    @fromPosition = @box.currentPosition() if !fromPosition?

  execute: ->
    @box.setPosition @toPosition.left, @toPosition.top

  undo: ->
    @box.setPosition @fromPosition.left, @fromPosition.top
