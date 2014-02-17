#= require Command
#= require Constants

class ChangeBoxNameCommand extends Command

  constructor: (@editor, boxId, @pageNum, @prevName, @newName) ->
    super()
    @boxIds.push boxId

  execute: ->
    @editor.panel.setBoxName @boxIds[0], @newName.substr(0, Constants.HUNK_NAME_MAX_NUM_OF_CHAR)

  undo: ->
    @editor.panel.setBoxName @boxIds[0], @prevName.substr(0, Constants.HUNK_NAME_MAX_NUM_OF_CHAR)

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum