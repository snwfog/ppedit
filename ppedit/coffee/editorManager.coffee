#= require CreateBoxCommand
#= require MoveBoxCommand
#= require Canvas
#= require RemoveBoxesCommand
#= require BoxesContainer
#= require Grid

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []
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
        $('.ppedit-box').trigger 'containerMouseMove', [event, delta]
        $('.ppedit-canvas').trigger 'containerMouseMove', [event, delta]

        @prevMouseEvent = event

      .mouseleave =>
        $('.ppedit-box').trigger 'containerMouseLeave'
        $('.ppedit-canvas').trigger 'containerMouseLeave'

      .mouseup =>
        $('.ppedit-box').trigger 'containerMouseUp'
        $('.ppedit-canvas').trigger 'containerMouseUp'

      .keydown (event) =>
        $('.ppedit-box').trigger 'containerKeyDown', [event]

      .on 'boxMoved', (event, box, currentPosition, originalPosition) =>
        @pushCommand(new MoveBoxCommand(box, currentPosition, originalPosition), false)

      .on 'canvasRectSelect', (event, rect) =>
        @boxesContainer.selectBoxesInRect rect

    @boxesContainer = new BoxesContainer @element
    @canvas = new Canvas @element
    @grid = new Grid @element

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @boxesContainer.element, options

  removeBox: (options) ->
    @pushCommand new RemoveBoxesCommand @boxesContainer.element, $('.ppedit-box')

  deleteOnFocus: ->
    if $('.ppedit-box:focus, .ppedit-box-selected').length > 0
      @pushCommand new RemoveBoxesCommand @boxesContainer.element, $('.ppedit-box:focus, .ppedit-box-selected')

  pushCommand: (command, execute ) ->
    command.execute() if !execute? || execute
    @undoStack.unshift command

  undo: ->
    if @undoStack.length > 0
      lastExecutedCommand = @undoStack.shift()
      lastExecutedCommand.undo()
      @redoStack.unshift lastExecutedCommand

  redo: ->
    @pushCommand @redoStack.shift() if @redoStack.length > 0
