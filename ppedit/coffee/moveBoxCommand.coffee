#= require ICommand

class moveBoxCommand extends ICommand

  @prevPosition

	constructor: (aBox, aNewPosition) ->
    	@box = aBox
    	@newPosition = aNewPosition

    execute: ->
    	@prevPosition = @box.getPosition()
    	@box.setPosition(@newPosition)

    undo: ->
    	@box.setPosition(@prevPosition)