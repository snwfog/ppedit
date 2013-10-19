#= require Box

class ChangeFontSizeCommand

  constructor: (@editor, @newFontSize, boxesSelector) ->

    @prevFontSize = {}
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.area.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    for box in @boxes
      @prevFontSize[box] = box.element.css("font-size")
    @editor.area.boxesContainer.changeFontSize @boxIds, @newFontSize

  undo: ->
    for box in @boxes
      box.element.css("font-size", @prevFontSize[box])