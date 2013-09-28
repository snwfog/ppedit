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
      selectRect.topLeft.x -= selectRect.size.width
      selectRect.size.width *= -1

    if selectRect.size.height < 0
      selectRect.topLeft.y -= selectRect.size.height
      selectRect.size.height *= -1

    $('.ppedit-box').each (index, box) ->
      $(box).addClass 'ppedit-box-selected' if BoxesContainer._rectContainsRect selectRect, Box.bounds($(box))

  @_rectContainsRect: (outerRect, innerRect) ->
#    true
    return (innerRect.topLeft.x >= outerRect.topLeft.x &&
      innerRect.topLeft.y >= outerRect.topLeft.y &&
      innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width &&
      innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height)