#= require Box

class ChangeFontTypeCommand

  constructor: (@editor, @newFontType, boxesSelector) ->

    @prevFontType = {}
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.area.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    for box in @boxes
      @prevFontType[box] = box.element.css("font-family")
    @editor.area.boxesContainer.changeFontType @boxIds, @newFontType

  undo: ->
    for box in @boxes
      box.element.css("font-family", @prevFontType[box])