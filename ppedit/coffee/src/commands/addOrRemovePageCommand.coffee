#= require Box
#= require Command
#= require EditArea

###
Command Used To Add Or Remove one Page
###
class AddOrRemoveCommand extends Command

  constructor: (@editor, @addPage, @pageNum) ->
    super()
    @area = undefined ;

    @boxIds = if @editor.areas[@pageNum]? then Object.getOwnPropertyNames(@editor.areas[pageNum].boxesContainer.boxes) else []

  execute: ->
    if @addPage
      @pageNum = @editor.areas.length if !@pageNum?
      @_insertNewPage @pageNum
    else
      @_removePage(@pageNum)

  undo: ->
    if @addPage then @_removePage(@pageNum) else @_insertPage(@pageNum, @area)

  _insertNewPage: (pageNum) ->
    newArea = new EditArea @editor.element, @editor.areas.length
    newArea.buildElement()
    @_insertPage pageNum, newArea
    @area = newArea

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

    # Insert @area into the areas array at position pagenum
    @editor.areas = @editor.areas.slice(0, pageNum)
      .concat([area])
      .concat(@editor.areas.slice(pageNum))

    for i in [0..@editor.areas.length-1]
      @editor.areas[i].element.attr('id', 'ppedit-page-' + i)

  _removePage:(pageNum) ->
    @area = @editor.areas.splice(pageNum, 1)[0]
    @area.element.detach()
    @editor.panel.removeTab pageNum

    for i in [0..@editor.areas.length-1]
      @editor.areas[i].element.attr('id', 'ppedit-page-' + i)
      @editor.areas[i].grid.toggleGrid()
      @editor.areas[i].grid.toggleGrid()

  getType: ->
    return if @addPage then 'addPage' else 'removePage'

  getPageNum: ->
    return @pageNum