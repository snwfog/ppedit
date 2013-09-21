#= require CreateBoxCommand

class EditorManager

  constructor: (@root) ->
    @undoStack = []
    @redoStack = []

  pushCommand: (command) ->
    command.execute()
    @undoStack.push(command)

  createBox: (options) ->
    @pushCommand new CreateBoxCommand @root, options

	moveBox: ->

	undoCommand: ->
		if undoStack.length isnt 0
			lastExecutedCommand = @undoStack.pop
			@redoStack.push(lastExecutedCommand)
			lastExecutedCommand.undo()

	redoCommand: ->
		if @redoStack.length isnt 0
			lastUndoCommand = @redoStack.pop
			@undoStack.push(lastUndoCommand)
			lastUndoCommand.execute()		