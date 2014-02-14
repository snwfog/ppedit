#= require Graphic
#= require Canvas
#= require BoxesContainer
#= require Grid

###
A graphic acting as a container of a boxesContainer, a canvas and a grid.
###
class EditArea extends Graphic

  constructor: (@root, @pageNum) ->
    super @root

    @prevMouseMoveEvent = undefined
    @canvas = undefined
    @grid = undefined
    @boxesContainer = undefined
    @fontPanel = undefined

  buildElement: ->
    @element = $('<div class="editContainer shadow-effect"></div>')
      .attr('id', 'ppedit-page-' + @pageNum)
      .append('<div></div>')
      .addClass("ppedit-container")
      .addClass("col-xs-8")
      .attr('tabindex', 0)

    @boxesContainer = new BoxesContainer @element, @root
    @canvas = new Canvas @element
    @grid = new Grid @element
    # @fontPanel = new FontPanel @element

    @boxesContainer.buildElement()
    @canvas.buildElement()
    @grid.buildElement()
    # @fontPanel.buildElement()
    
    @element.append @boxesContainer.element
    @element.append @canvas.element
    @element.append @grid.element
    # @element.append @fontPanel.element

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
    
      # .on 'boxSelected', (event, box) =>
        # @fontPanel.setSettingsFromStyle box.element.get(0).style

    @boxesContainer.bindEvents()
    @canvas.bindEvents()
    @grid.bindEvents()

