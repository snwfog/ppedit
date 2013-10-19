#= require Box

class ItalicFontCommand

  constructor: (@editor, boxesSelector) ->

    @prevStatus = {}
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.area.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    for box in @boxes
      @prevStatus[box] = box.element.css('font-style')
      if(box.element.css('font-style') == 'italic')
        box.element.css('font-style', 'normal')
      else
        box.element.css('font-style', 'italic')

  undo: ->
    for box in @boxes
      box.element.css('font-style', @prevStatus[box])