#= require Graphic
#= require Box

class BoxesContainer extends Graphic

  constructor: (@root) ->
    super @root
    @boxes = {}

  buildElement: ->
    @element = $('<div></div>').addClass('ppedit-box-container')

  bindEvents: ->
    @element.dblclick (event) =>
      event.preventDefault()
      boxCssOptions =
        left:event.offsetX + @element.scrollLeft()
        top:event.offsetY + @element.scrollTop()
      @root.trigger 'addBoxRequested', [boxCssOptions] if @getSelectedBoxes().length == 0

  ###
  Selects the boxes contained in the passed rect.
  The rect position is relative to the root.
  ###
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

    @getAllBoxes().each (index, box) =>
      @boxes[box.id].select() if BoxesContainer._rectContainsRect selectRect, @boxBounds($(box))

  ###
  Returns the bounding rectangle of the box matching the
  passed box selector.
  ###
  boxBounds: (boxSelector) ->
    result =
      topLeft:
        x:boxSelector.position().left + @element.scrollLeft()
        y:boxSelector.position().top + @element.scrollTop()
      size:
        width:boxSelector.width()
        height:boxSelector.height()

  ###
  Adds the passed Box Object to the Box List
  ###
  addBox: (box) ->
    box.buildElement() if !box.element?
    @element.append box.element
    box.bindEvents()
    @boxes[box.element.attr('id')] = box

  ###
  Given an array of box ids, deletes all box objects
  with those ids.
  ###
  removeBoxes: (boxIds) ->
    for id in boxIds
      @boxes[id].element
        .removeClass('ppedit-box-selected')
        .remove()
      delete @boxes[id]

  ###
  Returns an array of Box objects corresponding to the
  passed boxIds.
  ###
  getBoxesFromIds: (boxIds) ->
    return (@boxes[id] for id in boxIds when @boxes[id]?)

  ###
  Returns a selector matching all boxes
  ###
  getAllBoxes: ->
    return @element.find '.ppedit-box'

  ###
  Returns a selector to the currently selected boxes
  ###
  getSelectedBoxes: ->
    return @element.find '.ppedit-box:focus, .ppedit-box-selected'

  ###
  Returns a selector to the currently selected boxes,
  excluding the focused one, if any.
  ###
  getNotFocusedSelectedBoxes: ->
    return @element.find '.ppedit-box-selected'

  chageBoxOpacity: (boxid, opacityVal) ->
    @boxes[boxid].element.css("opacity", opacityVal)

  ###
  Returns true if the innerRect Rectangle is fully
  contained within the outerRect Rectangle, false otherwise.
  ###
  @_rectContainsRect: (outerRect, innerRect) ->
    return (innerRect.topLeft.x >= outerRect.topLeft.x &&
    innerRect.topLeft.y >= outerRect.topLeft.y &&
    innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width &&
    innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height)
