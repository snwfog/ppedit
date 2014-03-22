#= require Box
#= require Command

###
Command used to change the style of a specific box
###
class ChangeStyleCommand extends Command

  constructor: (@editor, @boxesSelector, @newCssOptions) ->
    super()
    @pageNum = @editor.getPageNum @boxesSelector.first()
    @boxesToCopy = @boxesSelector.clone()

  execute: ->
    @boxesSelector.each (index, item) =>
      $(item).css(@newCssOptions)

  undo: ->
    @boxesToCopy.each (index, item) =>
      prevCssOptions = CSSJSON.toJSON(@boxesToCopy.filter('#' + item.id).attr('style')).attributes
      @boxesSelector.filter('#' + item.id).css prevCssOptions

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum
