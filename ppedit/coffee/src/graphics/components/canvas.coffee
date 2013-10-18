#= require Graphic

class Canvas extends Graphic

  constructor: (@root) ->
    super @root

    @downPosition = undefined
    @rectSize = undefined
    @_context = undefined

  buildElement: ->
    @element = $('<canvas></canvas>')
      .addClass('ppedit-canvas')
      .attr('width', '600px')
      .attr('height', '960px')

  bindEvents:->
    @element
      .on 'containerMouseDown', (event, mouseEvent) =>
        @downPosition =
          left:mouseEvent.offsetX
          top:mouseEvent.offsetY
        @rectSize =
          width:0
          height:0

      .on 'containerMouseMove', (event, mouseMoveEvent, delta) =>
        if @downPosition? && @rectSize? && delta?
          @rectSize.width += delta.x
          @rectSize.height += delta.y
          @drawRect @downPosition, @rectSize

      .on 'containerMouseLeave', () =>
        @clear()

      .on 'containerMouseUp', () =>
        @root.trigger 'canvasRectSelect', [
          topLeft:@downPosition
          size:@rectSize] if @downPosition? && @rectSize?
        @clear()

    @_context = @element.get(0).getContext('2d')

  drawRect: (topLeft, size) ->
    @_context.clearRect(0, 0, @element.width(), @element.height())
    @_context.globalAlpha = 0.2
    @_context.beginPath()
    @_context.rect(topLeft.left, topLeft.top, size.width, size.height)
    @_context.fillStyle = 'blue'
    @_context.fill()

  clear: ->
    @_context.clearRect(0, 0, @element.width(), @element.height())
    @downPosition = undefined
    @rectSize = undefined



