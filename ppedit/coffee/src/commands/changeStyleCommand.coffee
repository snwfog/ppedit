#= require Box

class ChangeStyleCommand

  constructor: (@editor, boxesSelector, @newCssOptions) ->
    @boxesToCopy = boxesSelector.clone()
    @boxes = @editor.area.boxesContainer.getBoxesFromSelector boxesSelector

  execute: ->
    box.element.css(@newCssOptions) for id, box of @boxes

  undo: ->
    @boxesToCopy.each (index, item) =>
      prevCssOptions = CSSJSON.toJSON(@boxesToCopy.filter('#' + item.id).attr('style')).attributes
      @boxes[item.id].element.css prevCssOptions