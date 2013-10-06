#= require Box

class RemoveBoxesCommand

  ###
  Class constructor, omit the boxesSelector argument to
  issue a command for removing all boxes.
  ###
  constructor: (@editor, boxesSelector) ->

    if boxesSelector?
      # Getting the boxes to delete
      boxArray = boxesSelector.toArray()
      @boxIds = (box.id for box in boxArray)
    @boxes = @editor.editorManager.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    @editor.editorManager.boxesContainer.removeBoxes @boxIds

    if @boxIds?
      @editor.panel.element.find("tr[ppedit-box-id="+ boxId + "]").remove() for boxId in @boxIds

  undo: ->
    @editor.editorManager.boxesContainer.addBox box for box in @boxes

    if @boxIds?
      @editor.panel.addElement "dataPanel", boxId for boxId in @boxIds




