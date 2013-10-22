#= require Box

class ChangeDepthCommand

  ###
  Specify one Command for changing the depth of a box,
  where @boxSelector refers to the box to move, and 
  @moveUp is the parameter that specify the box to move up
  if true, or down if false.
  ###
  constructor: (@editor, @boxSelector, @moveUp) ->
   
  execute: ->
    if @moveUp then @swapRowWithUpperRow() else @swapRowWithLowerRow()

  undo: ->
    if @moveUp then @swapRowWithLowerRow() else @swapRowWithUpperRow()

  swapRowWithUpperRow: ->
    row = @editor.panel.getRowWithBoxId(@boxSelector.attr('id'))
    index = row.index()

    if index-1 >= 0
      upperRow = @editor.panel.getRowAtIndex index-1
      @swapRows row, upperRow

  swapRowWithLowerRow: ->
    row = @editor.panel.getRowWithBoxId(@boxSelector.attr('id'))
    index = row.index()

    if index < @editor.panel.element.find('.ppedit-panel-row').length-1
      lowerRow = @editor.panel.getRowAtIndex index+1
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
      rowOneBox = @editor.area.boxesContainer.boxes[rowOne.attr('ppedit-box-id')]
      rowOneBoxTempZindex = rowOneBox.element.css 'z-index'
      rowTwoBox = @editor.area.boxesContainer.boxes[rowTwo.attr('ppedit-box-id')]

      rowOneBox.element.css 'z-index', rowTwoBox.element.css('z-index')
      rowTwoBox.element.css 'z-index', rowOneBoxTempZindex