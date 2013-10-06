###
Class that manages a set of commands to undo/redo.
###
class CommandManager

  constructor: ->
    @undoStack = []
    @redoStack = []

  ###
  Inserts the passed command into the undo stack
  flow. This method executes the command by default, set
  the execute argument to false in order to prevent that behavior.
  ###
  pushCommand: (command, execute ) ->
    command.execute() if !execute? or execute
    @undoStack.push command
    @redoStack.splice 0, @redoStack.length

  ###
  Undo the last executed command
  ###
  undo: ->
    if @undoStack.length > 0
      lastCommand = @undoStack.pop()
      lastCommand.undo()
      @redoStack.push lastCommand

  ###
  Redo the last executed command
  ###
  redo: ->
    if @redoStack.length > 0
      redoCommand = @redoStack.pop()
      redoCommand.execute()
      @undoStack.push redoCommand