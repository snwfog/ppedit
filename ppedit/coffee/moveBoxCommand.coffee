#= require ICommand
#= require Box

class MoveBoxCommand extends ICommand

	constructor: (@box, @toPosition, fromPosition) ->
    @prevStyle = @box.element.get(0).style
    if fromPosition?
      @prevStyle.left = fromPosition.x
      @prevStyle.top = fromPosition.y

  execute: ->
    @box.css
      left:@toPosition.x + 'px'
      top:@toPosition.y + 'px'

  undo: ->
    @box.css
      left:@prevStyle.left
      top:@prevStyle.top