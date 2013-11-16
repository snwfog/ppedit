#= require Graphic
#= require Geometry
#= require BoxHelper

class Box extends Graphic

  constructor: (@root, @options)->
    super @root

    @prevPosition = undefined
    @helper = new BoxHelper this

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
      .attr('tabindex', 0)
      .attr('contenteditable', true)
      .attr('id', $.now())
      .css(settings)

  bindEvents: ->
    @element
      .mousedown (event) =>
        event.stopPropagation()
        event.preventDefault()

      .click (event) =>
        event.stopPropagation()
        event.preventDefault()
        @toggleSelect()

      .dblclick (event) =>
        event.stopPropagation()
        event.preventDefault()
        @stopMoving()
        @toggleFocus()
      
      .on 'containerMouseMove', (event, mouseMoveEvent, delta) =>
        @move delta.x, delta.y if @element.hasClass('ppedit-box-selected') && delta?

      .on 'containerMouseLeave', () =>
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

  setPosition: (x, y) ->
    @element.css 'left', x + 'px'
    @element.css 'top', y + 'px'

  currentPosition: ->
    @element.position()

  snap: ->
    snappedPosition = @getSnapPosition(@currentPosition())
    @setPosition snappedPosition.left, snappedPosition.top

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

  toggleSelect: ->
    if @element.hasClass('ppedit-box-selected')
      @stopMoving()
    else
      @root.find('.ppedit-box').removeClass('ppedit-box-selected')
      @select() if !@isFocused()

  toggleFocus: ->
      @root.find('.ppedit-box')
        .removeClass('ppedit-box-focus')
        .removeClass('ppedit-box-selected')
      @element
        .addClass('ppedit-box-focus')
        .focus()

  addBulletPoint: ->
    @_addHtml $('<ul><li></li></ul>')

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