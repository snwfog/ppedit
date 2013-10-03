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
    @pushCommand new CreateBoxCommand @boxesContainer.element, @boxesContainer, options

  removeBox: (options) ->
    @pushCommand new RemoveBoxesCommand @boxesContainer.element, @boxesContainer

  deleteSelectedBoxes: ->
    selectedBoxes = $('.ppedit-box:focus, .ppedit-box-selected')
    if selectedBoxes.length > 0
      @pushCommand new RemoveBoxesCommand @boxesContainer.element, @boxesContainer, selectedBoxes

  pushCommand: (command, execute ) ->
    command.execute() if !execute? or execute
    @undoStack.push command
    @redoStack.splice 0, @redoStack.length

  undo: ->
    if @undoStack.length > 0
      lastCommand = @undoStack.pop()
      lastCommand.undo()
      @redoStack.push lastCommand

  redo: ->
    if @redoStack.length > 0
      redoCommand = @redoStack.pop()
      redoCommand.execute()
      @undoStack.push redoCommand
