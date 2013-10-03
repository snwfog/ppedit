#= require ICommand
#= require Box
#= require BoxesContainer

class RemoveBoxesCommand extends ICommand

  ###
  Class constructor, omit the boxesSelector argument to
  issue a command for removing all boxes.
  ###
  constructor: (@root, @boxesContainer, boxesSelector) ->
    super @root

    if boxesSelector?
      # Getting the boxes to delete
      boxArray = boxesSelector.toArray()
      @boxIds = (box.id for box in boxArray)
    @boxes = @boxesContainer.getBoxesFromIds @boxIds
    console.log @boxes

  execute: ->
    @boxesContainer.removeBoxes @boxIds

  undo: ->
    for id, box of @boxes
      @boxesContainer.addBox box

