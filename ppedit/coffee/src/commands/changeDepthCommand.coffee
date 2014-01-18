#= require Box
#= require Command

class ChangeDepthCommand extends Command

  ###
  Specify one Command for changing the depth of a box,
  where @boxSelector refers to the box to move, and 
  @moveUp is the parameter that specify the box to move up
  if true, or down if false.
  ###
  constructor: (@editor, @editContainer, boxSelector, @moveUp) ->
    super()
    @boxId = boxSelector.attr('id')
    @boxIds.push @boxId

  execute: ->
    if @moveUp then @swapRowWithUpperRow() else @swapRowWithLowerRow()

  undo: ->
    if @moveUp then @swapRowWithLowerRow() else @swapRowWithUpperRow()

  swapRowWithUpperRow: ->
    if @editContainer
      row = @editor.panel1.getRowWithBoxId(@boxId)
      index = row.index()

      if index-1 >= 0
        upperRow = @editor.panel1.getRowAtIndex index-1
        @swapRows row, upperRow
    else
      row = @editor.panel2.getRowWithBoxId(@boxId)
      index = row.index()

      if index-1 >= 0
        upperRow = @editor.panel2.getRowAtIndex index-1
        @swapRows row, upperRow

  swapRowWithLowerRow: ->
    if @editContainer
      row = @editor.panel1.getRowWithBoxId(@boxId)
      index = row.index()

      if index+1 < @editor.panel1.element.find('.ppedit-panel-row').length
        lowerRow = @editor.panel1.getRowAtIndex index+1
        @swapRows row, lowerRow
    else
      row = @editor.panel2.getRowWithBoxId(@boxId)
      index = row.index()

      if index+1 < @editor.panel2.element.find('.ppedit-panel-row').length
        lowerRow = @editor.panel2.getRowAtIndex index+1
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
      if @editContainer
        rowOneBox = @editor.area1.boxesContainer.boxes[rowOne.attr('ppedit-box-id')]
        rowOneBoxTempZindex = rowOneBox.element.css 'z-index'
        rowTwoBox = @editor.area1.boxesContainer.boxes[rowTwo.attr('ppedit-box-id')]

        rowOneBox.element.css 'z-index', rowTwoBox.element.css('z-index')
        rowTwoBox.element.css 'z-index', rowOneBoxTempZindex
      else
        rowOneBox = @editor.area2.boxesContainer.boxes[rowOne.attr('ppedit-box-id')]
        rowOneBoxTempZindex = rowOneBox.element.css 'z-index'
        rowTwoBox = @editor.area2.boxesContainer.boxes[rowTwo.attr('ppedit-box-id')]

        rowOneBox.element.css 'z-index', rowTwoBox.element.css('z-index')
        rowTwoBox.element.css 'z-index', rowOneBoxTempZindex

  getType: ->
    return 'Modify'



