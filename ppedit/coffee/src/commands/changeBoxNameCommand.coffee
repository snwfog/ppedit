class ChangeBoxNameCommand extends Command

  constructor: (@editor, boxId, @pageNum, @prevName, @newName) ->
    super()
    @boxIds.push boxId

  execute: ->
    @editor.panel.setBoxName @boxIds[0], @newName

  undo: ->
    @editor.panel.setBoxName @boxIds[0], @prevName

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum