#= require Box

class UnderlineFontCommand

  constructor: (@editor, boxesSelector) ->

    @prevStatus = {}
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.area.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    for box in @boxes
      @prevStatus[box] = box.element.css('text-decoration')
      if(box.element.css('text-decoration') == 'underline')
        box.element.css('text-decoration', 'none')
      else
        box.element.css('text-decoration', 'underline')

  undo: ->
    for box in @boxes
      box.element.css('text-decoration', @prevStatus[box])