#= require Graphic
#= require Geometry
#= require BoxHelper

class Box extends Graphic

  @CLICK_TIME_MILLIS:200
  @DBLCLICK_TIME_MILLIS:200

  constructor: (@root, @options)->
    super @root

    @helper = new BoxHelper this

    @prevPosition = undefined

    @prevMouseDownTime = 0
    @prevMouseUpTime = 0
    @clickCount = 0

    @clickTimeoutId = 0

  buildElement: ->
    highestZIndex = undefined

    boxs = @root.find('.ppedit-box')
    if boxs.length > 0
      highestZIndex = 0
      boxs.each (index, nodeElement) ->
        highestZIndex = Math.max highestZIndex, parseInt($(nodeElement).css('z-index'))

    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'75px'
      height:'50px'
      color : 'black'
      'font-family':'Times New Roman'
      'font-size': '100%'
      'font-weight': 'normal'
      'text-decoration': 'none'
      'font-style': 'normal'
      'z-index' : if highestZIndex? then (highestZIndex + 1) else 0;
      'text-align': 'left'
      'vertical-align': 'bottom'
    , @options);

    @element = $('<div></div>')
      .addClass('ppedit-box')
      .attr('contenteditable', true)
      .attr('id', $.now())
      .css(settings)

  bindEvents: ->
    @element
      .mousedown (event) =>
        event.stopPropagation()
        event.preventDefault()

        @select()
        @prevMouseDownTime = event.timeStamp

      .mouseup (event) =>
        event.preventDefault()

        if event.timeStamp - @prevMouseDownTime < Box.CLICK_TIME_MILLIS

          # Click is happening
          @clickCount++

          if @clickTimeoutId == 0
            @clickTimeoutId = setTimeout ( =>
              if @clickCount == 1
                @_onClick()

              else if @clickCount >= 2
                @_onDoubleClick()

              @clickTimeoutId = 0
              @clickCount = 0

            ), Box.DBLCLICK_TIME_MILLIS

        @stopMoving()


      .click (event) =>
        event.stopPropagation()
        event.preventDefault()
        @toggleSelect()
        fontElement = $(document).find('.row')
        fontValue = $(event.target).css('font-family')
        sizeValue = $(event.target).css('font-size')
        fontElement.trigger 'fontSettings', [fontValue, sizeValue]


      .dblclick (event) =>
        event.stopPropagation()
        event.preventDefault()

      .on 'containerMouseMove', (event, mouseMoveEvent, delta) =>
        @move delta.x, delta.y if @element.hasClass('ppedit-box-selected') && delta?

      .on 'containerMouseLeave', () =>
        @stopMoving()

      .on 'containerMouseUp', (event, mouseMoveEvent) =>
        @stopMoving()

      .on 'containerKeyDown', (event, keyDownEvent) =>
        @_processKeyDownEvent(keyDownEvent) if @element.hasClass('ppedit-box-selected')

    .keydown (event) =>
        @_processKeyDownEvent(event) if !@isFocused()

    @helper.bindEvents()
      
  ###
  Matches directional arrows event
  to pixel-by-pixel movement
  ###
  _processKeyDownEvent: (event) ->

      previousPosition = @currentPosition()
      moved = false

      # left-arrow
      if event.which == 37
        event.preventDefault()
        moved = true
        @move -1, 0

      # up-arrow
      if event.which == 38
        event.preventDefault()
        moved = true
        @move 0, -1

      # right-arrow
      if event.which == 39
        event.preventDefault()
        moved = true
        @move 1, 0

      # down-arrow
      if event.which == 40
        event.preventDefault()
        moved = true
        @move 0, 1

      @element.trigger 'boxMoved', [@, @currentPosition(), previousPosition] if moved

  ###
  Deselects the box
  ###
  stopMoving: ->
    @element.removeClass('ppedit-box-selected')
    if @prevPosition? && !Geometry.pointEqualToPoint(@currentPosition(), @prevPosition) 
      if $(document).find('.snapBtn').hasClass('snapBtn-selected')
        @snap()
      @root.trigger 'boxMoved', [@, $.extend(true, {}, @currentPosition()), $.extend(true, {}, @prevPosition)]
    @prevPosition = undefined
    if $(document).find('.snapBtn').hasClass('snapBtn-selected')
      @root.find('.hDotLine')
        .removeClass('ppedit-hDotLine')
      @root.find('.vDotLine')
        .removeClass('ppedit-vDotLine')

  ###
  Moves the box by the passed delta amounts.
  ###
  move: (deltaX, deltaY) ->
    currentPos = @currentPosition()
    @setPosition deltaX + currentPos.left, deltaY + currentPos.top
    dotLinePos = @getSnapPosition(@currentPosition())
    if $(document).find('.snapBtn').hasClass('snapBtn-selected')
      @root.find('.hDotLine')
        .addClass('ppedit-hDotLine')
        .css 'top', dotLinePos.top
      @root.find('.vDotLine')
        .addClass('ppedit-vDotLine')
        .css 'left', dotLinePos.left

  ###
  Sets the position of the box to the passed coordinates
  ###
  setPosition: (x, y) ->
    @element.css 'left', x + 'px'
    @element.css 'top', y + 'px'

  ###
  Returns the current position of the box.
  ###
  currentPosition: ->
    @element.position()

  ###
  Sets the position of the box to the nearest snapping
  position.
  ###
  snap: ->
    snappedPosition = @getSnapPosition(@currentPosition())
    @setPosition snappedPosition.left, snappedPosition.top

  ###
  Returns the coordinates of the snapping position nearest
  to the box.
  ###
  getSnapPosition: (p) ->
    snapedLeft = parseInt(p.left/8)*8
    snapedTop = parseInt(p.top/8)*8
    return {left: snapedLeft, top: snapedTop}

  ###
  Marks the box as selected
  ###
  select: ->
    @element.addClass('ppedit-box-selected')
    @prevPosition = @currentPosition()

  ###
  Returns true if the element is currently focused, false otherwise
  ###
  isFocused: ->
    return @element.get(0) == document.activeElement

  ###
  Puts the box on focus.
  ###
  _enableFocus: ->
      @root.find('.ppedit-box')
        .removeClass('ppedit-box-focus')
        .removeClass('ppedit-box-selected')
      @element
        .addClass('ppedit-box-focus')
        .focus()

  ###
  Adds an unordered point list at the current position
  of the cursor in the box
  ###
  addBulletPoint: ->
    @_addHtml $('<ul><li></li></ul>')

  ###
  Adds an ordered list at the current position
  of the cursor in the box
  ###
  addOrderedPointList: ->
    @_addHtml $('<ol><li></li></ol>')

  _addHtml: (htmlSelector) ->
    editedElement = $(window.getSelection().getRangeAt(0).startContainer.parentNode)
    editedElement = @element if editedElement.closest('.ppedit-box').length == 0
    htmlSelector.find('li').html editedElement.html()

    # Adding the htmlElement
    editedElement
      .empty()
      .append htmlSelector

    # TODO: Set the cursor position to the beginning of the Bullet list

  _getCursorPosition: ->
    return window.getSelection().getRangeAt(0).startOffset

  _onClick: ->

  _onDoubleClick: ->
    @_enableFocus()
