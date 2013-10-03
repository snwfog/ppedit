#= require Box


class BoxesContainer
  constructor: (@root) ->
    @element = $('<div></div>').addClass('ppedit-box-container')
    @root.append(@element)
    @boxes = []

  selectBoxesInRect: (rect) ->

    # translate rectangle by the scrollPosition
    selectRect =
      topLeft:
        x:rect.topLeft.x + @element.scrollLeft()
        y:rect.topLeft.y + @element.scrollTop()
      size:rect.size

    if selectRect.size.width < 0
      selectRect.topLeft.x -= Math.abs(selectRect.size.width)
      selectRect.size.width = Math.abs(selectRect.size.width)

    if selectRect.size.height < 0
      selectRect.topLeft.y -= Math.abs(selectRect.size.height)
      selectRect.size.height = Math.abs(selectRect.size.height)

    $('.ppedit-box').each (index, box) =>
      $(box).addClass 'ppedit-box-selected' if BoxesContainer._rectContainsRect selectRect, @boxBounds($(box))

  boxBounds: (boxSelector) ->
    result =
      topLeft:
        x:boxSelector.position().left + @element.scrollLeft()
        y:boxSelector.position().top + @element.scrollTop()
      size:
        width:boxSelector.width()
        height:boxSelector.height()

  @_rectContainsRect: (outerRect, innerRect) ->
    return (innerRect.topLeft.x >= outerRect.topLeft.x &&
      innerRect.topLeft.y >= outerRect.topLeft.y &&
      innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width &&
      innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height)

  createBox: (options) ->
    box = new Box @root, @options
    @addBox box
    return box

  addBox: (box) ->
    @element.append box.element
    @boxes.push box

  removeBoxes: (boxes) ->
    boxes = @boxes if !boxes?
    for box in boxes
      box.element.remove()
      #boxIndex = @boxes.indexOf(box)
      #@boxes.splice boxIndex, 1
    @boxes = []








