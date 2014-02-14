#= require Box
#= require Command
#= require EditArea

class AddOrRemoveCommand extends Command

  constructor: (@editor, @addPage, @pageNum) ->
    @area = undefined ;
    super()

  execute: ->
    if @addPage
      @pageNum = @editor.areas.length if !@pageNum?
      @_insertNewPage @pageNum
    else
      @_removePage(@pageNum)

  undo: ->
    @_removePage(@pageNum) if @addPage else @_insertPage @pageNum, @area

  _insertNewPage: (pageNum) ->
    newArea = new EditArea @editor.element, @editor.areas.length
    newArea.buildElement()
    @_insertPage pageNum, newArea
    @area = newArea

    # Insert @area into the areas array at position pagenum
    @editor.areas = @editor.areas.slice(0, pageNum)
      .concat([@area])
      .concat(@editor.areas.slice(pageNum, @editor.areas.length))

  _insertPage:(pageNum, area) ->
    if pageNum > 0
      area.element.insertAfter(@editor.superContainer.children().eq(pageNum-1))
    else
      @editor.superContainer.append area.element

    area.bindEvents()

    panel = @editor.panel
    panel.insertTab pageNum

    # Add row associated with box in the panel.
    for id, box of area.boxesContainer.boxes
      rows = panel.getRows pageNum
      if rows.length == 0
        panel.addBoxRow id
      else
        # Insert new row in panel at a position
        # determined by its associated box's z-index property.
        rows.each (index, rowNode) =>
          otherBoxId = $(rowNode).attr('ppedit-box-id')
          otherBoxZIndex = area.boxesContainer.boxes[otherBoxId].element.css('z-index')

          if (parseInt(otherBoxZIndex) < parseInt(box.element.css('z-index')) or
          index == rows.length - 1)
            panel.addBoxRow id, index
            return false # break statement

  _removePage:(pageNum) ->
    @area = @editor.areas.splice(pageNum, 1)
    @area.element.remove()
    @editor.panel.removeTab(pageNum)

  getType: ->
    return 'Modify'