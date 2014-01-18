#= require Box
#= require Command

class CopyBoxesCommand extends Command

  constructor: (@editor, @editPage, @boxesClones) ->
    super()
    @newBoxes = []

  execute: ->
    if @newBoxes.length == 0
      @boxesClones.each (index, boxItem) =>
        boxOptions = CSSJSON.toJSON(boxItem.style.cssText).attributes
        if @editPage
          box = new Box @editor.area1.boxesContainer.element, boxOptions
        else
          box = new Box @editor.area2.boxesContainer.element, boxOptions
        @newBoxes[index] = box

    for i in [0..@newBoxes.length-1]
      box = @newBoxes[i]
      if @editPage
        @editor.area1.boxesContainer.addBox box
        box.element.html @boxesClones.eq(i).html()
        @editor.panel1.addBoxRow box.element.attr('id')
        @boxIds[i] = box.element.attr('id')
      else
        @editor.area2.boxesContainer.addBox box
        box.element.html @boxesClones.eq(i).html()
        @editor.panel2.addBoxRow box.element.attr('id')
        @boxIds[i] = box.element.attr('id')


  undo: ->
    for box in @newBoxes
      if @editPage
        @editor.area1.boxesContainer.removeBoxes [box.element.attr('id')]
        @editor.panel1.removeBoxRow [box.element.attr('id')]
      else
        @editor.area2.boxesContainer.removeBoxes [box.element.attr('id')]
        @editor.panel2.removeBoxRow [box.element.attr('id')]

  getType: ->
    return 'Create'