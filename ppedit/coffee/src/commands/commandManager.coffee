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

    history =
      modified:({} for i in [0..@initNumOfPages-1])
      removed:({} for i in [0..@initNumOfPages-1])
      created:({} for i in [0..@initNumOfPages-1])

    for command in @undoStack
      for id in command.boxIds

        switch command.getType()
          when 'Create'
            history.created[command.getPageNum()]['' + id] =
              id:id
              html:$('#' + id).clone().wrap('<div></div>').parent().html() or ''
              name:$('tr[ppedit-box-id=' + id + ']').find('input').val()

          when 'Modify'
            if !history.created[command.getPageNum()]['' + id]?
              history.modified[command.getPageNum()]['' + id] =
                id:id
                html:$('#' + id).clone().wrap('<div></div>').parent().html() or ''
                name:$('tr[ppedit-box-id=' + id + ']').find('input').val()

          when 'Remove'
            delete history.modified[command.getPageNum()]['' + id]

            if history.created[command.getPageNum()]['' + id]?
              delete history.created[command.getPageNum()]['' + id]
            else
              history.removed[command.getPageNum()]['' + id] =
                id:id
                html:''
                name:''

          when 'removePage'
            delete history.modified[command.getPageNum()]['' + id]

            if history.created[command.getPageNum()]['' + id]?
              delete history.created[command.getPageNum()]['' + id]
            else
              history.removed[command.getPageNum()]['' + id] =
                id:id
                html:''
                name:''

      if command.getType() == 'removePage'
        if command.getPageNum() < history.modified.length - 2
          history.modified[command.getPageNum()] = $.extend history.modified[command.getPageNum()], history.modified[command.getPageNum()+1]
          history.created[command.getPageNum()] = $.extend history.created[command.getPageNum()], history.created[command.getPageNum()+1]
          history.removed[command.getPageNum()] = $.extend history.removed[command.getPageNum()], history.removed[command.getPageNum()+1]

          history.modified.splice command.getPageNum()+1, 1
          history.created.splice command.getPageNum()+1, 1
          history.removed.splice command.getPageNum()+1, 1

      else if command.getType() == 'addPage'
        history.modified.push {}
        history.created.push {}
        history.removed.push {}

    result =
      modified:((value for key, value of page) for page in history.modified)
      removed:((value for key, value of page) for page in history.removed)
      created:((value for key, value of page) for page in history.created)

    # hashing the history changeset
    shaObj = new jsSHA(JSON.stringify(history), "TEXT");
    hunkId = shaObj.getHMAC("", "TEXT", "SHA-256", "HEX");
    result.etag = hunkId

    return JSON.stringify(result)

  ###
  Deletes the history of commands issued since the editor has been loaded.
  ###
  clearHistory: ->
    @undoStack.splice 0, @undoStack.length
