#= require Graphic
#= require Canvas
#= require BoxesContainer
#= require Grid

###
A graphic acting as a container of a boxesContainer, a canvas and a grid.
###
class EditArea extends Graphic

  constructor: (@root) ->
    super @root

    @prevMouseMoveEvent = undefined
    @canvas = undefined
    @grid = undefined
    @boxesContainer = undefined

  buildElement: ->
    @element = $('<div></div>')
      .addClass("ppedit-container")
      .addClass("col-xs-8")
      .attr('tabindex', 0)

    @boxesContainer = new BoxesContainer @element
    @canvas = new Canvas @element
    @grid = new Grid @element

    @boxesContainer.buildElement()
    @canvas.buildElement()
    @grid.buildElement()
    
    @element.append @boxesContainer.element
    @element.append @canvas.element
    @element.append @grid.element

  bindEvents:->
    @element
      .mousedown =>
        if @boxesContainer.getNotFocusedSelectedBoxes().length == 0
          @canvas.element.trigger 'containerMouseDown', [event]

      .mousemove (event) =>
        delta = undefined
        if @prevMouseMoveEvent?
          delta =
            x: event.clientX - @prevMouseMoveEvent.clientX
            y: event.clientY - @prevMouseMoveEvent.clientY
        @element.find('*').trigger 'containerMouseMove', [event, delta]
        @prevMouseMoveEvent = event

      .mouseleave =>
        @element.find('*').trigger 'containerMouseLeave'
        @prevMouseMoveEvent = undefined

      .mouseup (event) =>
        @element.find('*').trigger 'containerMouseUp', [event]
        @prevMouseMoveEvent = undefined

      .keydown (event) =>
        @element.find('*').trigger 'containerKeyDown', [event]

      .on 'canvasRectSelect', (event, rect) =>
        @boxesContainer.selectBoxesInRect rect

    @boxesContainer.bindEvents()
    @canvas.bindEvents()
    @grid.bindEvents()