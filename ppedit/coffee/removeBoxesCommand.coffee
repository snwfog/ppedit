#= require ICommand
#= require Box
#= require BoxesContainer

class RemoveBoxesCommand extends ICommand

  constructor: (@root, @boxesContainer, @boxes) ->
    super @root
    @boxes = @boxesContainer.boxes

  execute: ->
    @boxesContainer.removeBoxes()

  undo: ->
    for item in @boxes
      @boxesContainer.addBox item
      item.bindEvents()
