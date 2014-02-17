#= require Command
#= require Box
#= require AddOrRemoveCommand

###
A command that populates the editor with the boxes
information defined in a json string.
###
class LoadBoxesCommand extends Command

  ###
  Defines a command that, when executed, populates the editor with the boxes
  information defined in the passed json string.

  The jsonBoxes parameter must be a json string like the following :
  [
    {
      "box-id-1":'<div class="ppedit-box">box-id-1 contents in page 1</div>',
      "box-id-2":'<div class="ppedit-box">box-id-2 contents in page 1</div>'
    },
    {
      "box-id-3":'<div class="ppedit-box">box-id-3 contents in page 2</div>',
      "box-id-4":'<div class="ppedit-box">box-id-4 contents in page 2</div>'
    }
  ]
  ###
  constructor: (@editor, @jsonBoxes) ->
    super()

  execute: ->
    pages = @jsonBoxes

    # Adding new pages if there are not enough
    if pages.length > @editor.areas.length
      for i in [0..pages.length - @editor.areas.length]
        addCmd = new AddOrRemoveCommand @editor, true
        addCmd.execute()

    for i in [0..pages.length-1]
      for id, boxElement of pages[i]
        area = @editor.areas[i]
        panel = @editor.panel

        box = new Box area.boxesContainer.element
        box.element = $(boxElement.html)
        area.boxesContainer.addBox box

        # Add row associated with box in the panel.
        rows = panel.getRows i
        if rows.length == 0
          panel.addBoxRow i, id
        else
          # Insert new row in panel at a position
          # determined by its associated box's z-index property.
          rows.each (index, rowNode) =>

            otherBoxId = $(rowNode).attr('ppedit-box-id')
            otherBoxZIndex = area.boxesContainer.boxes[otherBoxId].element.css('z-index')

            if (parseInt(otherBoxZIndex) < parseInt(box.element.css('z-index')) or
                index == rows.length - 1)
              panel.addBoxRow i, id, index
              return false # break statement

        panel.setBoxName id, boxElement.name


  undo: ->
    return # no need to implement for now.

  getType: ->
    return 'Create'

  getPageNum: ->
    return # no need to implement for now.