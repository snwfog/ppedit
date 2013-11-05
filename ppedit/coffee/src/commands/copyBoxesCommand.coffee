#= require Box
#= require Command

class CopyBoxesCommand extends Command

  constructor: (@editor, @boxesClones) ->
    super()
    @newBoxes = []

  execute: ->
    if @newBoxes.length == 0
      @boxesClones.each (index, boxItem) =>
        boxOptions = CSSJSON.toJSON(boxItem.style.cssText).attributes
        box = new Box @editor.area.boxesContainer.element, boxOptions
        @newBoxes[index] = box

    for i in [0..@newBoxes.length-1]
      box = @newBoxes[i]
      @editor.area.boxesContainer.addBox box
      box.element.html @boxesClones.eq(i).html()
      @editor.panel.addBoxRow box.element.attr('id')
      @boxIds[i] = box.element.attr('id')


  undo: ->
    for box in @newBoxes
      @editor.area.boxesContainer.removeBoxes [box.element.attr('id')]
      @editor.panel.removeBoxRow [box.element.attr('id')]

  getType: ->
    return 'Create'