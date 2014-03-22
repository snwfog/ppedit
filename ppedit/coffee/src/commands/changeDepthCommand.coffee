#= require Box
#= require Command

###
Command used to change the z-index of a specific box
###
class ChangeDepthCommand extends Command

  ###
  Specify one Command for changing the depth of a box,
  where @boxSelector refers to the box to move, and 
  @moveUp is the parameter that specify the box to move up
  if true, or down if false.
  ###
  constructor: (@editor, @pageNum, boxSelector, @moveUp) ->
    super()
    @boxId = boxSelector.attr('id')

  execute: ->
    if @moveUp then @swapRowWithUpperRow() else @swapRowWithLowerRow()

  undo: ->
    if @moveUp then @swapRowWithLowerRow() else @swapRowWithUpperRow()

  swapRowWithUpperRow: ->
    row = @editor.panel.getRowWithBoxId(@boxId)
    index = row.index()

    if index-1 >= 0
      upperRow = @editor.panel.getRowAtIndex @pageNum, index-1
      @swapRows row, upperRow

  swapRowWithLowerRow: ->
    row = @editor.panel.getRowWithBoxId(@boxId)
    index = row.index()

    if index+1 < @editor.panel.getRows(@pageNum).length
      lowerRow = @editor.panel.getRowAtIndex @pageNum, index+1
      @swapRows row, lowerRow

  ###
  Swaps RowOne with RowTwo. Also swaps the z-index of the boxes
  associated with each row.
  ###
  swapRows: (rowOne, rowTwo) ->
      # Swap lowerRow and row
      if(rowOne.index() < rowTwo.index())
        rowOne.insertAfter(rowTwo)
      else   
        rowOne.insertBefore(rowTwo)

      #swap z-index of RowOne and RowTwo
      rowOneBox = @editor.areas[@pageNum].boxesContainer.boxes[rowOne.attr('ppedit-box-id')]
      rowOneBoxTempZindex = rowOneBox.element.css 'z-index'
      rowTwoBox = @editor.areas[@pageNum].boxesContainer.boxes[rowTwo.attr('ppedit-box-id')]

      rowOneBox.element.css 'z-index', rowTwoBox.element.css('z-index')
      rowTwoBox.element.css 'z-index', rowOneBoxTempZindex

  getType: ->
    return 'Modify'

  getPageNum: ->
    return @pageNum



