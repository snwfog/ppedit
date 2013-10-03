#= require Box


class BoxesContainer
  constructor: (@root) ->
    @element = $('<div></div>').addClass('ppedit-box-container')
    @root.append(@element)
    @boxes = {}

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

  createBox: (options) ->
    box = new Box @root, @options
    @addBox box
    return box

  ###
  Adds the passed Box Object to the Box List
  ###
  addBox: (box) ->
    console.log box
    @element.append box.element
    box.bindEvents()
    @boxes[box.element.attr('id')] = box

  ###
  Returns an array of Box objects matching the
  passed Selector
  ###
  boxesFromSelector: (selector) ->
    @element.find(selector).each ->

  ###
  Deletes the Box objects corresponding to the
  passed boxIds. Passing no arguments will delete
  all Box objects.
  ###
  removeBoxes: (boxIds) ->
    if !boxIds?
      box.element.remove() for boxId, box of @boxes
      @boxes = {}
    else
      for id in boxIds
        @boxes[id].element.remove()
        delete @boxes[id]

  ###
  Returns the Box objects corresponding to the
  passed boxIds. Passing no arguments will return
  all Box objects.
  ###
  getBoxesFromIds: (boxIds) ->
    if boxIds?
      return {id:@boxes[id]} for id in boxIds when @boxes[id]?
    else
      return $.extend(true, {}, @boxes)

  ###
  Returns true if the innerRect Rectangle is fully
  contained in the outerRect Rectangle, false otherwise.
  ###
  @_rectContainsRect: (outerRect, innerRect) ->
    return (innerRect.topLeft.x >= outerRect.topLeft.x &&
    innerRect.topLeft.y >= outerRect.topLeft.y &&
    innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width &&
    innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height)







