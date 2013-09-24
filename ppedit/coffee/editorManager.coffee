#= require CreateBoxCommand
#= require MoveBoxCommand

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []
    @build()

  build: ->
    @root.addClass("ppedit-container")
      .on 'dragover', (event) ->
        event.preventDefault()
        boxId = event.originalEvent.dataTransfer.getData 'boxId'
        boxNewX = event.originalEvent.offsetX - event.originalEvent.dataTransfer.getData 'mouseOffsetX'
        boxNewY = event.originalEvent.offsetY - event.originalEvent.dataTransfer.getData 'mouseOffsetY'
        @moveBox $('#' + boxId), boxNewX, boxNewY


      .on 'drop', (event) =>
        # Move the box to mouse drop position
        event.preventDefault()
        boxId = event.originalEvent.dataTransfer.getData 'boxId'
        boxNewX = event.originalEvent.offsetX - event.originalEvent.dataTransfer.getData 'mouseOffsetX'
        boxNewY = event.originalEvent.offsetY - event.originalEvent.dataTransfer.getData 'mouseOffsetY'
        @moveBox $('#' + boxId), boxNewX, boxNewY

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @root, options

  moveBox: (box, newX, newY) ->
    @pushCommand new MoveBoxCommand box, newX, newY

  pushCommand: (command) ->
    command.execute()
    @undoStack.push(command)

  undo: ->
    if @undoStack.length > 0
      lastExecutedCommand = @undoStack.pop
      lastExecutedCommand.undo()
      @redoStack.push(lastExecutedCommand)

  redo: ->
    if @redoStack.length > 0
      @pushCommand @redoStack.pop
