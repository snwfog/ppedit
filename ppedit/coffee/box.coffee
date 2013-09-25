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

    @element = $('<div></div>')
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

  stopMoving: ->
    @mouseDown = false
    @root.trigger 'boxMoved', [@, $.extend(true, {}, @prevPosition)]
    @prevPosition = undefined

  currentPosition: ->
    x: parseInt @element.css 'left'
    y: parseInt @element.css 'top'