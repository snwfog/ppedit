class BoxesContainer
  constructor: (@root) ->
    @element = $('<div></div>').addClass('ppedit-box-container')
    @root.append(@element)

  selectBoxesInRect: (rect) ->

    # translate rectangle by the scrollPosition
    selectRect =
      topLeft:
        x:rect.topLeft.x + @element.scrollLeft()
        y:rect.topLeft.y + @element.scrollTop()
      size:rect.size

  selectBoxes: (boxesSelector) ->
    boxesSelector.addClass('ppedit-box-selected')