#= require Box
#= require BoxesContainer

class RemoveBoxesCommand

  ###
  Class constructor, omit the boxesSelector argument to
  issue a command for removing all boxes.
  ###
  constructor: (@boxesContainer, boxesSelector) ->
    if boxesSelector?
      # Getting the boxes to delete
      boxArray = boxesSelector.toArray()
      @boxIds = (box.id for box in boxArray)
    @boxes = @boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    @boxesContainer.removeBoxes @boxIds

  undo: ->
    for id, box of @boxes
      @boxesContainer.addBox box

