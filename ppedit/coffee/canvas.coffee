class Canvas
  constructor: (@root) ->
    @element = undefined
    @downPosition = undefined
    @rectSize = undefined
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
      @rectSize =
        width:0
        height:0

    .on 'containerMouseMove', (event, mouseMoveEvent, delta) =>
      if @downPosition? && @rectSize?
        @rectSize.width += delta.x
        @rectSize.height += delta.y
        @drawRect @downPosition, @rectSize

    .on 'containerMouseLeave', () =>
      @clear()

    .on 'containerMouseUp', () =>
      @root.trigger 'canvasRectSelect', [
        topLeft:@downPosition
        size:@rectSize]
      @clear()

    @root.append(@element)
    @_context = @element.get(0).getContext('2d')

  drawRect: (topLeft, size) ->
    @_context.clearRect(0, 0, @element.width(), @element.height())
    @_context.globalAlpha = 0.2
    @_context.beginPath()
    @_context.rect(topLeft.x, topLeft.y, size.width, size.height)
    @_context.fillStyle = 'blue'
    @_context.fill()

  clear: ->
    @_context.clearRect(0, 0, @element.width(), @element.height())
    @downPosition = undefined
    @rectSize = undefined



