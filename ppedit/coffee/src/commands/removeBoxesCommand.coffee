#= require Box

class RemoveBoxesCommand

  constructor: (@editor, boxesSelector) ->

    # Getting the boxes to delete
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.editorManager.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    @editor.editorManager.boxesContainer.removeBoxes @boxIds
    @editor.panel.removeBoxRow boxId for boxId in @boxIds

  undo: ->
    for box in @boxes
      @editor.editorManager.boxesContainer.addBox box
      @editor.panel.addBoxRow box.element.attr 'id'