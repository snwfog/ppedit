#= require Box
#= require Command

class ChangeStyleCommand extends Command

  constructor: (@editor, @boxesSelector, @newCssOptions) ->
    super()
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
