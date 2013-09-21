class EditorManager

	undoStack : []
	redoStack : []

	createBox: ->

	moveBox: ->
	
	pushCommand: (command) ->
		command.execute()
		unoStack.push(command)

	undoCommand: ->
		if undoStack.length isnt 0
			lastExecutedCommand = undoStack.pop
			redoStack.push(lastExecutedCommand)
			lastExecutedCommand.undo()

	redoCommand: ->
		if redoStack.length isnt 0
			lastUndoCommand = redoStack.pop
			undoStack.push(lastUndoCommand)
			lastUndoCommand.execute()		