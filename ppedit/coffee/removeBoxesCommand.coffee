#= require ICommand
#= require Box

class RemoveBoxesCommand extends ICommand

  constructor: (@root, @boxes) ->
    super @root

  execute: ->
    @boxes.remove()

  undo: ->
    @root.append(@boxes)
