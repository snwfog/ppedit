#= require Graphic

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

    @element = $('<textarea></textarea>')
    .addClass('ppedit-box')
    .attr('tabindex', 0)
    .css('font-family', 'Times New Roman')
    .attr('id', $.now())
    .css(settings)

  bindEvents: ->
    @element
      .mousedown (event) =>
        event.preventDefault()
        @select()

      .dblclick =>
        @element.focus()

      .on 'containerMouseMove', (event, mouseMoveEvent, delta) =>
        @move delta.x, delta.y if @element.hasClass('ppedit-box-selected') && delta?

      .on 'containerMouseLeave', () =>
        @stopMoving()

      .on 'containerMouseUp', () =>
        @stopMoving()

      .on 'containerKeyDown', (event, keyDownEvent) =>
        @_processKeyDownEvent(keyDownEvent) if @element.hasClass('ppedit-box-selected')

      .keydown (event) =>
        @_processKeyDownEvent(event)

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
