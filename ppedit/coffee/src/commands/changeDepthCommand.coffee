#= require Box

class MoveUpCommand

  constructor: (@editor, @boxSelector) ->
   

  execute: ->
    row = @editor.panel.getRowWithBoxId(@boxSelector.attr('id'))
    index = row.index()

    if index-1 >= 0

      # Swap upperRow and row
      upperRow = @editor.panel.getRowAtIndex index-1
      row.insertBefore(upperRow)

      #swap z-index of upperRow and row
      temp = @boxSelector.css('z-index')
      upperRowBox = @editor.area.boxesContainer.boxes[upperRow.attr('ppedit-box-id')]

      @boxSelector.css 'z-index', upperRowBox.element.css('z-index')
      upperRowBox.element.css 'z-index', temp

  undo: ->
    row = @editor.panel.getRowWithBoxId(@boxSelector.get(0).id)
    index = row.index()

    if index < @editor.panel.element.find('.ppedit-panel-row').length-1

      # Swap lowerRow and row
      lowerRow = @editor.panel.getRowAtIndex index+1
      row.insertAfter(lowerRow)

      #swap z-index of lowerRow and row
      temp = @boxSelector.css('z-index')
      upperRowBox = @editor.area.boxesContainer.boxes[lowerRow.attr('ppedit-box-id')]

      @boxSelector.css 'z-index', upperRowBox.element.css('z-index')
      upperRowBox.element.css 'z-index', temp    
 