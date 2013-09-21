#= require ICommand

class CreateBoxCommand extends ICommand

	@prevState

	constructor: (aBox, aNewState) ->
    	@box = aBox
    	@newState = aNewState

  execute: ->
    @prevState = @box.isStateOn()
    @box.setState(@newState)

  undo: ->
    @box.setPosition(@prevState)