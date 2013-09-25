#= require CreateBoxCommand
#= require MoveBoxCommand

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []
    @prevMouseEvent = undefined
    @build()

  build: ->
    @root.addClass("ppedit-container")
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

      .on 'boxMoved', (event, box, originalPosition) =>
        @pushCommand(new MoveBoxCommand(box, box.currentPosition(), originalPosition), false)

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @root, options

  pushCommand: (command, execute ) ->
    execute = true if !execute?
    command.execute() if execute
    @undoStack.push(command)

  undo: ->
    if @undoStack.length > 0
      lastExecutedCommand = @undoStack.pop
      lastExecutedCommand.undo()
      @redoStack.push(lastExecutedCommand)

  redo: ->
    @pushCommand @redoStack.pop if @redoStack.length > 0
