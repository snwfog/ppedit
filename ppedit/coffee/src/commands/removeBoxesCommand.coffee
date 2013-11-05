#= require Box
#= require Command

class RemoveBoxesCommand extends Command

  constructor: (@editor, boxesSelector) ->
    super()
    
    # Getting the boxes to delete
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.area.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    @editor.area.boxesContainer.removeBoxes @boxIds
    @editor.panel.removeBoxRow boxId for boxId in @boxIds

  undo: ->
    for box in @boxes
      @editor.area.boxesContainer.addBox box
      @editor.panel.addBoxRow box.element.attr 'id'

  getType: ->
    return 'Remove'