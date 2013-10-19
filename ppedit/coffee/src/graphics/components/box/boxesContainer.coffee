#= require Graphic
#= require Box
#= require Geometry

class BoxesContainer extends Graphic

  @CLICK_TIME_INTERVAL: 200

  constructor: (@root) ->
    super @root

    @boxes = {}
    @lastDownEvent = undefined

  buildElement: ->
    @element = $('<div></div>').addClass('ppedit-box-container')

  bindEvents: ->
    @element
      .mousedown (event) =>
        @lastDownEvent = event
      
      .mouseup (event) =>
        # Click happened
        if @lastDownEvent? && event.timeStamp - @lastDownEvent.timeStamp < BoxesContainer.CLICK_TIME_INTERVAL
          @unSelectAllBoxes()

      .dblclick (event) =>
        event.preventDefault()
        boxCssOptions = @getPointClicked(event)
        @root.trigger 'addBoxRequested', [boxCssOptions] if @getSelectedBoxes().length == 0

  ###
  Selects the boxes contained in the passed rect.
  The rect position is relative to the root.
  ###
  selectBoxesInRect: (rect) ->
    # translate rectangle by the scrollPosition
    selectRect =
      topLeft:
        left:rect.topLeft.left + @element.scrollLeft()
        top:rect.topLeft.top + @element.scrollTop()
      size:rect.size

    if selectRect.size.width < 0
      selectRect.topLeft.left -= Math.abs(selectRect.size.width)
      selectRect.size.width = Math.abs(selectRect.size.width)

    if selectRect.size.height < 0
      selectRect.topLeft.top -= Math.abs(selectRect.size.height)
      selectRect.size.height = Math.abs(selectRect.size.height)

    @getAllBoxes().each (index, box) =>
      @boxes[box.id].select() if Geometry.rectContainsRect selectRect, @boxBounds($(box))

  ###
  Returns the bounding rectangle of the box matching the
  passed box selector.
  ###
  boxBounds: (boxSelector) ->
    result =
      topLeft:
        left:boxSelector.position().left + @element.scrollLeft()
        top:boxSelector.position().top + @element.scrollTop()
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

  unSelectAllBoxes: ->
    box.stopMoving() for id, box of @boxes

  ###
  Returns the position relative to the top left corner
  of the element from the passed mouseEvent.
  ###

  @_rectContainsRect: (outerRect, innerRect) ->
    return (innerRect.topLeft.x >= outerRect.topLeft.x &&
    innerRect.topLeft.y >= outerRect.topLeft.y &&
    innerRect.topLeft.x + innerRect.size.width <= outerRect.topLeft.x + outerRect.size.width &&
    innerRect.topLeft.y + innerRect.size.height <= outerRect.topLeft.y + outerRect.size.height)

  ###
  Given an array of box ids, change font type of all box objects
  with those ids.
  ###
  changeFontType: (boxIds, newFontType) ->
    for id in boxIds
      @boxes[id].element
        .css("font-family", newFontType)
  ###
  Given an array of box ids, change font size of all box objects
  with those ids.
  ###
  changeFontSize: (boxIds, newFontSize) ->
    for id in boxIds
      @boxes[id].element
        .css("font-size", newFontSize)

  getPointClicked: (mouseEvent) ->
    return {
      left:event.offsetX + @element.scrollLeft()
      top:event.offsetY + @element.scrollTop()
    }
