#= require CreateBoxCommand
#= require MoveBoxCommand
#= require Canvas
#= require RemoveBoxesCommand
#= require BoxesContainer

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []
    @prevMouseEvent = undefined
    @canvas = undefined
    @boxesContainer = undefined

    @build()

  build: ->
    @root.addClass("ppedit-container")
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

    @boxesContainer = new BoxesContainer @root
    @canvas = new Canvas @root

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @boxesContainer.element, options

  removeBox: (options) ->
    @pushCommand new RemoveBoxesCommand @boxesContainer.element, $('.ppedit-box')

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
