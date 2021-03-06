#= require Box
#= require Command

###
Command used to remove one or more boxes.
###
class RemoveBoxesCommand extends Command

  constructor: (@editor, @pageNum, boxesSelector) ->
    super()
    
    # Getting the boxes to delete
    boxArray = boxesSelector.toArray()
    @boxIds = (box.id for box in boxArray)
    @boxes = @editor.areas[@pageNum].boxesContainer.getBoxesFromIds @boxIds

  execute: ->
    @editor.areas[@pageNum].boxesContainer.removeBoxes @boxIds
    @editor.panel.removeBoxRow boxId for boxId in @boxIds

  undo: ->
    for box in @boxes
      @editor.areas[@pageNum].boxesContainer.addBox box
      @editor.panel.addBoxRow box.element.attr 'id'

  getType: ->
    return 'Remove'

  getPageNum: ->
    return @pageNum