#= require ICommand
#= require Box

class MoveBoxCommand extends ICommand

	constructor: (@box, @toPosition, @fromPosition) ->
    @fromPosition = @box.currentPosition() if !fromPosition?

  execute: ->
    @box.setPosition(@toPosition.x, @toPosition.y)

  undo: ->
    console.log @
    @box.setPosition(@fromPosition.x, @fromPosition.y)
