#= require Box
#= require Command

class RemoveBoxesCommand extends Command

  constructor: (@editor, @editContainer, boxesSelector) ->
    super()
    
    # Getting the boxes to delete
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    if @editContainer
      @boxes = @editor.area1.boxesContainer.getBoxesFromIds @boxIds
    else
      @boxes = @editor.area2.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    if @editContainer
      @editor.area1.boxesContainer.removeBoxes @boxIds
      @editor.panel1.removeBoxRow boxId for boxId in @boxIds
    else
      @editor.area2.boxesContainer.removeBoxes @boxIds
      @editor.panel2.removeBoxRow boxId for boxId in @boxIds
  undo: ->
    for box in @boxes
      if @editContainer
        @editor.area1.boxesContainer.addBox box
        @editor.panel1.addBoxRow box.element.attr 'id'
      else
        @editor.area2.boxesContainer.addBox box
        @editor.panel2.addBoxRow box.element.attr 'id'
  getType: ->
    return 'Remove'