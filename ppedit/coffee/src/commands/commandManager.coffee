#= require Constants

###
Class that manages a set of commands to undo/redo.
###
class CommandManager

  constructor: ->
    @initNumOfPages = Constants.INIT_NUM_OF_PAGES
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
  Returns a json string specifying the boxes that have been created, modified and/or removed.
  ###
  getUndoJSON: ->

    result =
      modified:({} for i in [0..@initNumOfPages-1])
      removed:({} for i in [0..@initNumOfPages-1])
      created:({} for i in [0..@initNumOfPages-1])

    for command in @undoStack
      for id in command.boxIds

        switch command.getType()
          when 'Create'
            result.created[command.getPageNum()]['' + id] =
              $('#' + id).clone().wrap('<div></div>').parent().html() or ''

          when 'Modify'
            if !result.created[command.getPageNum()]['' + id]?
              result.modified[command.getPageNum()]['' + id] = $('#' + id).clone().wrap('<div></div>').parent().html() or ''

          when 'Remove'
            delete result.modified[command.getPageNum()]['' + id]

            if result.created[command.getPageNum()]['' + id]?
              delete result.created[command.getPageNum()]['' + id]
            else
              result.removed[command.getPageNum()]['' + id] = ''

          when 'removePage'
            delete result.modified[command.getPageNum()]['' + id]

            if result.created[command.getPageNum()]['' + id]?
              delete result.created[command.getPageNum()]['' + id]
            else
              result.removed[command.getPageNum()]['' + id] = ''

      if command.getType() == 'removePage'
        if command.getPageNum() < result.modified.length - 2
          result.modified[command.getPageNum()] = $.extend result.modified[command.getPageNum()], result.modified[command.getPageNum()+1]
          result.created[command.getPageNum()] = $.extend result.created[command.getPageNum()], result.created[command.getPageNum()+1]
          result.removed[command.getPageNum()] = $.extend result.removed[command.getPageNum()], result.removed[command.getPageNum()+1]

          result.modified.splice command.getPageNum()+1, 1
          result.created.splice command.getPageNum()+1, 1
          result.removed.splice command.getPageNum()+1, 1

      else if command.getType() == 'addPage'
        result.modified.push {}
        result.created.push {}
        result.removed.push {}

    # hashing the result changeset
    shaObj = new jsSHA(JSON.stringify(result), "TEXT");
    hunkId = shaObj.getHMAC("", "TEXT", "SHA-256", "HEX");
    result.etag = hunkId

    return JSON.stringify(result)

  ###
  Deletes the history of commands issued since the editor has been loaded.
  ###
  clearHistory: ->
    @undoStack.splice 0, @undoStack.length
