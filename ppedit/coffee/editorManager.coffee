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

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @root, options

  moveBox: (box, newX, newY) ->
    @pushCommand new MoveBoxCommand box, newX, newY

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
    if @redoStack.length > 0
      @pushCommand @redoStack.pop
