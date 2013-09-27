#= require CreateBoxCommand
#= require MoveBoxCommand
#= require RemoveBoxesCommand

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []
    @prevMouseEvent = undefined
    @build()

  build: ->
    @root.addClass("ppedit-container")
      .attr('tabindex', 0)
      .mousemove (event) =>
        delta = undefined
        if @prevMouseEvent?
          delta =
            x: event.clientX - @prevMouseEvent.clientX
            y: event.clientY - @prevMouseEvent.clientY
        $('.ppedit-box').trigger 'containerMouseMove', [delta]
        @prevMouseEvent = event

      .mouseleave =>
        $('.ppedit-box').trigger 'containerMouseLeave'

      .mouseup =>
        $('.ppedit-box').trigger 'containerMouseUp'

      .keydown (event) =>
        $('.ppedit-box').trigger 'containerKeyDown', [event]

      .on 'boxMoved', (event, box, originalPosition) =>
          @pushCommand(new MoveBoxCommand(box, box.currentPosition(), originalPosition), false)

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @root, options

  removeBox: (options) ->
    @pushCommand new RemoveBoxesCommand @root, $('.ppedit-box')

  pushCommand: (command, execute ) ->
    execute = true if !execute?
    command.execute() if execute
    @undoStack.unshift command

  undo: ->
    if @undoStack.length > 0
      lastExecutedCommand = @undoStack.shift()
      lastExecutedCommand.undo()
      @redoStack.unshift lastExecutedCommand

  redo: ->
    @pushCommand @redoStack.shift() if @redoStack.length > 0
