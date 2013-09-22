#= require ICommand

class MoveBoxCommand extends ICommand

	constructor: (@box, @newX, @newY) ->
    @prevStyle = @box.get(0).style

  execute: ->
    @box.css
      left:@newX + 'px'
      top:@newY + 'px'

  undo: ->
    @box.css
      left:@prevStyle.left
      top:@prevStyle.top