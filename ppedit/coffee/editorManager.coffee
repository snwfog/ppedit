#= require CreateBoxCommand
#= require MoveBoxCommand

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []

    @root.addClass("ppedit-container")
      .on 'dragover', (event) ->
        event.preventDefault()
        
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

  #undoCommand: ->
	#	if @undoStack.length isnt 0
#			lastExecutedCommand = @undoStack.pop
#			@redoStack.push(lastExecutedCommand)
#			lastExecutedCommand.undo()

#  redoCommand: ->
#		if @redoStack.length isnt 0
#			@pushCommand @redoStack.pop
