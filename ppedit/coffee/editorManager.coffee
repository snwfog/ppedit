#= require CreateBoxCommand
#= require MoveBoxCommand
#= require Canvas
#= require RemoveBoxesCommand
#= require BoxesContainer
#= require Grid

class EditorManager

  constructor: (@root) ->
    @prevMouseEvent = undefined
    @canvas = undefined
    @grid = undefined
    @boxesContainer = undefined
    @element = undefined

    @build()

  build: ->
    @element = $('<div></div>')
    @root.append(@element)

    @element.addClass("ppedit-container")
      .addClass("col-xs-8")
      .attr('tabindex', 0)
      .mousedown =>
        if $('.ppedit-box-selected').length == 0
          $('.ppedit-canvas').trigger 'containerMouseDown', [event]

      .mousemove (event) =>
        delta = undefined
        if @prevMouseEvent?
          delta =
            x: event.clientX - @prevMouseEvent.clientX
            y: event.clientY - @prevMouseEvent.clientY
        @element.find('*').trigger 'containerMouseMove', [event, delta]
        @prevMouseEvent = event

      .mouseleave =>
        @element.find('*').trigger 'containerMouseLeave'

      .mouseup =>
        @element.find('*').trigger 'containerMouseUp'

      .keydown (event) =>
        @element.find('*').trigger 'containerKeyDown', [event]

      .on 'canvasRectSelect', (event, rect) =>
        @boxesContainer.selectBoxesInRect rect

    @boxesContainer = new BoxesContainer @element
    @canvas = new Canvas @element
    @grid = new Grid @element
