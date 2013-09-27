class Canvas
  constructor: (@root) ->
    @element = undefined
    @downPosition = undefined
    @build()

  build: ->
    @element = $('<canvas></canvas>')
    .addClass('ppedit-canvas')
    .attr('width', '1000px')
    .attr('height', '500px')
    .on 'containerMouseDown', (event, mouseEvent) =>
      @downPosition =
        x:mouseEvent.offsetX
        y:mouseEvent.offsetY

    .on 'containerMouseMove', (event, mouseMoveEvent, delta) =>
      if @downPosition?
        rectSize =
          width:mouseMoveEvent.offsetX - @downPosition.x
          height:mouseMoveEvent.offsetY - @downPosition.y
        @drawRect @downPosition, rectSize

    .on 'containerMouseLeave', () =>
      @clear()

    .on 'containerMouseUp', () =>
      @clear()

    @root.append(@element)
    @_context = @element.get(0).getContext('2d')

  drawRect: (topLeft, size) ->
    @_context.clearRect(0, 0, @element.width(), @element.height())
    @_context.beginPath()
    @_context.rect(topLeft.x, topLeft.y, size.width, size.height)
    @_context.fillStyle = 'blue'
    @_context.fill()

  clear: ->
    @_context.clearRect(0, 0, @element.width(), @element.height())
    @downPosition = undefined



