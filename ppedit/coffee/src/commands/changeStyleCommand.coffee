#= require Box
#= require Command

class ChangeStyleCommand extends Command

  constructor: (@editor, boxesSelector, @newCssOptions) ->
    super()
    boxesSelector.each (index, item) =>
      @boxIds.push item.id
    @boxesToCopy = boxesSelector.clone()
    @boxes = @editor.area.boxesContainer.getBoxesFromSelector boxesSelector

  execute: ->
    box.element.css(@newCssOptions) for id, box of @boxes

  undo: ->
    @boxesToCopy.each (index, item) =>
      prevCssOptions = CSSJSON.toJSON(@boxesToCopy.filter('#' + item.id).attr('style')).attributes
      @boxes[item.id].element.css prevCssOptions

  getType: ->
    return 'Modify'
