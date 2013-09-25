class Box

  constructor: (@root, options)->

    # true if the user is currently leftclicking on the box.
    @mouseDown = false
    @prevPosition = undefined

    settings = $.extend(
      left:'50px'
      top:'50px'
      width:'100px'
      height:'200px'
    , options);

    @element = $('<textarea></textarea>')
    .addClass('ppedit-box')
    .attr('id', $.now())
    .css(settings)
    .mousedown =>
      @mouseDown = true
      @prevPosition = @currentPosition()

    .on 'containerMouseMove', (event, delta) =>
      if @mouseDown && delta?
        currentPos = @currentPosition()
        @element.css 'left', (delta.x + currentPos.x) + 'px'
        @element.css 'top', (delta.y + currentPos.y) + 'px'

    .on 'containerMouseLeave', () =>
      @stopMoving()

    .on 'containerMouseUp', () =>
      @stopMoving()

    .keydown (event) =>

      event.preventDefault()

      # left-arrow
      if event.which == 37
        @move -1, 0

      # up-arrow
      if event.which == 38
        @move 0, -1

      # right-arrow
      if event.which == 39
        @move 1, 0

      # down-arrow
      if event.which == 40
        @move 0, 1

      @root.trigger 'boxMoved', [@, @currentPosition()]

  stopMoving: ->
    @mouseDown = false
    @root.trigger 'boxMoved', [@, $.extend(true, {}, @prevPosition)]
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