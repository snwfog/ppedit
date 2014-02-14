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

    @fontPanel = new FontPanel @root
    @fontPanel.buildElement()
    
    @boxesContainer.buildElement()
    @canvas.buildElement()
    @grid.buildElement()
    # @fontPanel.buildElement()
    
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
    
      .on 'boxSelected', (event, box) =>
        @fontPanel.setSettingsFromStyle box.element.get(0).style

      .on 'toolTipShowsUp', (event, leftPos,topPos,heightPos,widthPos) =>
        @showToolTip()
        @setToolTipPosition(leftPos,topPos,heightPos,widthPos)
    @fontPanel.bindEvents()

    @boxesContainer.bindEvents()
    @canvas.bindEvents()
    @grid.bindEvents()

  setToolTipPosition: (leftPos, topPos,heightPos,widthPos) ->
    toolTip = @fontPanel.element

    if(@element.height()-topPos-heightPos < toolTip.height()+10)
      if((@element.width()-leftPos-widthPos/2)<toolTip.width()+10)
        toolTip.css 'left', (leftPos+widthPos/2-toolTip.width()) + 'px'
      else
        toolTip.css 'left', (leftPos+widthPos/2) + 'px'
      toolTip.css 'top', (topPos-toolTip.height()-25) + 'px'

    else
      if((@element.width()-leftPos-widthPos/2)<toolTip.width()+10)
        toolTip.css 'left', (leftPos+widthPos/2-toolTip.width()) + 'px'
      else
        toolTip.css 'left', (leftPos+widthPos/2) + 'px'
      toolTip.css 'top', (topPos+heightPos+10) + 'px'

  showToolTip: ->
    @element.append @fontPanel.element

  removeToolTip: ->
    @fontPanel.element.remove()