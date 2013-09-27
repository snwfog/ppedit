class Canvas
  constructor: (@root) ->

    @element = $('<canvas></canvas>')
    .addClass('ppedit-canvas')

    @root.append(@element)

    @_context = @element.get(0).getContext('2d')
#    @_context.beginPath()
#    @_context.moveTo(100, 150)
#    @_context.lineTo(200, 50)
#    @_context.stroke()

