#= require Graphic
#= require Geometry

class Box extends Graphic

  constructor: (@root, @options)->
    super @root

    # true if the user is currently leftclicking on the box.
    @prevPosition = undefined

  buildElement: ->
    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'75px'
      height:'50px'
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

      .dblclick () =>
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

      @root.trigger 'boxMoved', [@, @currentPosition(), previousPosition] if moved

  stopMoving: ->

    @element.removeClass('ppedit-box-selected')
    if @prevPosition? && !Geometry.pointEqualToPoint(@currentPosition(), @prevPosition)
      @root.trigger 'boxMoved', [@, @currentPosition(), $.extend(true, {}, @prevPosition)] if @prevPosition?
    @prevPosition = undefined

  move: (deltaX, deltaY) ->
    currentPos = @currentPosition()
    @setPosition deltaX + currentPos.x, deltaY + currentPos.y

  setPosition: (x, y) ->
    @element.css 'left', x + 'px'
    @element.css 'top', y + 'px'

  currentPosition: ->
    x: parseInt @element.css 'left'
    y: parseInt @element.css 'top'

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
      @select()

  toggleFocus: ->
    if @isFocused()
      @element.blur()
    else
      @element.focus()