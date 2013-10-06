#= require Box

class MoveBoxCommand

	constructor: (@box, @toPosition, @fromPosition) ->
    @fromPosition = @box.currentPosition() if !fromPosition?

  execute: ->
    @box.setPosition(@toPosition.x, @toPosition.y)

  undo: ->
    @box.setPosition(@fromPosition.x, @fromPosition.y)
