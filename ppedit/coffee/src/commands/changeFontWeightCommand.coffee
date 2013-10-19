#= require Box

class ChangeFontWeightCommand

  constructor: (@editor, boxesSelector) ->

    @prevFontWeight = {}
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.area.boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    for box in @boxes
      @prevFontWeight[box] = box.element.css('font-weight')
      if(box.element.css('font-weight') == 400)
        box.element.css('font-weight', 'bold')
      else
        box.element.css('font-weight', 'normal')

  undo: ->
    for box in @boxes
      box.element.css('font-weight', @prevFontWeight[box])

###
  @prevStatus = JSONCSS.toJSON{boxesSelector.style. ...}
  command = new changeboxesstylecommand(boxes, {font-weight: 'bold'})

  ==>
    for all boxes
      save the boxes style in an array

    execute:
      json = $.extend(@prevstyle, {font-weight: 'bold'})
      box.element.css(json)
###