#= require Graphic
#= require Box
#= require Geometry

###
Graphic acting as a container of boxes.
###
class BoxesContainer extends Graphic

  @CLICK_TIME_INTERVAL: 200

  constructor: (@root, @superRoot) ->
    super @root
    @boxes = {}

  buildElement: ->
    console.log(@superRoot)
    @fontPanel = new FontPanel @superRoot
    @fontPanel.buildElement()
    @element = $('<div></div>').addClass('ppedit-box-container')
    @element.append('<p class="hDotLine"></p>')
    @element.append('<p class="vDotLine"></p>')

  bindEvents: ->
    editContainer = false
    @element
      .mousedown (event) =>
        event.preventDefault()
        @unSelectAllBoxes()

      .dblclick (event) =>
        boxCssOptions = @getPointClicked(event)
        @element.trigger 'addBoxRequested', [boxCssOptions] if @getSelectedBoxes().length == 0

      .click (event) =>
        @root.trigger 'unSelectBoxes'
        # @removeToolTip()

      .on 'boxSelected', (event, box) =>
        @fontPanel.setSettingsFromStyle box.element.get(0).style

      .on 'toolTipShowsUp', (event, leftPos,topPos,heightPos,widthPos) =>
        @showToolTip()
        @setToolTipPosition(leftPos,topPos,heightPos,widthPos)
    @fontPanel.bindEvents()

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
        .removeClass('ppedit-box-focus')
        .remove()
      delete @boxes[id]

  ###
  Returns an array of Box objects corresponding to the
  passed boxIds.
  ###
  getBoxesFromIds: (boxIds) ->
    return (@boxes[id] for id in boxIds when @boxes[id]?)

  ###
  Returns an list of box objects corresponding to the
  passed selector matching box elements.
  ###
  getBoxesFromSelector: (selector) ->
    results = {}
    for box in selector.toArray()
      results[box.id] = @boxes[box.id]
    return results

  ###
  Returns a selector matching all boxes
  ###
  getAllBoxes: ->
    return @element.find '.ppedit-box'

  ###
  Returns a selector to the currently selected boxes
  ###
  getSelectedBoxes: ->
    return @element.find '.ppedit-box:focus, .ppedit-box-selected, .ppedit-box-focus'

  ###
  Returns a selector to the currently selected boxes,
  excluding the focused one, if any.
  ###
  getNotFocusedSelectedBoxes: ->
    return @element.find '.ppedit-box-selected'

  ###
  Changes the opacity of one box

  @param boxid [Int] the id of the box to change
  @param opacityVal [Int] the value of the opacity to change the box to.
  ###
  changeBoxOpacity: (boxid, opacityVal) ->
    @boxes[boxid].element.css("opacity", opacityVal)

  ###
  Unselects all boxes.
  ###
  unSelectAllBoxes: ->
    for id, box of @boxes
      box.stopMoving()
      box.element
        .removeClass('ppedit-box-focus')
        .blur()

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
  Returns the mouse coordinates of the passed mouseEvent
  relative to the boxes Container position.
  ###
  getPointClicked: (mouseEvent) ->
    return {
      left:event.offsetX + @element.scrollLeft()
      top:event.offsetY + @element.scrollTop()
    }

  ###
  Returns a JSON object containing a description of
  all the boxes currently existing in this container.
  ###
  getAllHunks: ->
    return ({id:boxId, html:box.element.wrap("<div></div>").parent().html()} for boxId, box of @boxes)


  setToolTipPosition: (leftPos, topPos,heightPos,widthPos) ->
    toolTip = @fontPanel.element
    if(@element.height()-topPos-heightPos < toolTip.height()+10)
      if((@element.width()-leftPos-widthPos/2)<toolTip.width()+10)
        toolTip.css 'left', (leftPos+widthPos/2-toolTip.width()) + 'px'
      else
        toolTip.css 'left', (leftPos+widthPos/2) + 'px'
      toolTip.css 'top', (topPos-toolTip.height()-25) + 'px'

    else
      if((@element.width()-leftPos-widthPos/2)<toolTip.width()+10)
        toolTip.css 'left', (leftPos+widthPos/2-toolTip.width()) + 'px'
      else
        toolTip.css 'left', (leftPos+widthPos/2) + 'px'
      toolTip.css 'top', (topPos+heightPos+10) + 'px'

  showToolTip: ->
    @element.append @fontPanel.element

  removeToolTip: ->
    @fontPanel.element.remove()