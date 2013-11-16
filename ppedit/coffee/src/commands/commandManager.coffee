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


  ###
  executing the JSON command 
  ###
  getUndoJSON: ->
    modifiedBoxes = {}
    createdBoxes = {}
    removedBoxes = {}

    for command in @undoStack
      for id in command.boxIds             

        switch command.getType()
          when 'Create'
            createdBoxes['' + id] = $('#' + id).clone().wrap('<div></div>').parent().html() or ''

          when 'Modify'
            if !createdBoxes['' + id]?
              modifiedBoxes['' + id] = $('#' + id).clone().wrap('<div></div>').parent().html() or ''

          when 'Remove'
            delete modifiedBoxes['' + id]            

            if createdBoxes['' + id]?
              delete createdBoxes['' + id]
            else 
              removedBoxes['' + id] = ''

    # building the return object value
    result = {modified:{}, created:{}, removed: {}}
    result.modified[boxid] = value for boxid, value of modifiedBoxes
    result.created[boxid] = value for boxid, value of createdBoxes
    result.removed[boxid] = value for boxid, value of removedBoxes

    # hashing the result changeset
    shaObj = new jsSHA(JSON.stringify(result), "TEXT");
    hunkId = shaObj.getHMAC("", "TEXT", "SHA-256", "HEX");
    result.etag = hunkId

    return JSON.stringify(result)

  clearHistory: ->
    @undoStack.splice 0, @undoStack.length
