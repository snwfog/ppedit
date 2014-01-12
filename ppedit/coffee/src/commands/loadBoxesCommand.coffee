#= require Command
#= require Box

###
A command that populates the editor with the boxes
information defined in a json string.
###
class LoadBoxesCommand extends Command

  ###
  Defines a command that, when executed, populates the editor with the boxes
  information defined in the passed json string.

  The jsonBoxes parameter must be a json string like the following :
  {
    "box-id-1":'<div class="ppedit-box">box-id-1 contents</div>',
    "box-id-2":'<div class="ppedit-box">box-id-2 contents</div>'
  }
  ###
  constructor: (@editor, @jsonBoxes) ->
    super()

  execute: ->
    boxes = JSON.parse @jsonBoxes
    for id, boxElement of boxes
      box = new Box @editor.area.boxesContainer.element
      box.element = $(boxElement)
      @editor.area.boxesContainer.addBox box

      # Add row associated with box in the panel.
      rows = @editor.panel.getRows()
      if rows.length == 0
        @editor.panel.addBoxRow id
      else
        # Insert new row in panel at a position
        # determined by its associated box's z-index property.
        rows.each (index, rowNode) =>
          otherBoxId = $(rowNode).attr('ppedit-box-id')
          otherBoxZIndex = @editor.area.boxesContainer.boxes[otherBoxId].element.css('z-index')

          if (parseInt(otherBoxZIndex) < parseInt(box.element.css('z-index')) or
              index == rows.length - 1)
            @editor.panel.addBoxRow id, index
            return false # break statement

  undo: ->
    return # no need to implement for now.

  getType: ->
    return 'Create'