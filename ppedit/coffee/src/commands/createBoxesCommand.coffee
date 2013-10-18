#= require Box

###
A command that creates one or more boxes with the passed options
ands adds it to the list.
###
class CreateBoxesCommand

  ###
  Creates a command that, when executed, will create
  one or more boxes with a passed list of options, one
  for each box to create and add it to the list of current boxes.
  If no optionsList is passed, only one box is created with the default options.
  ###
  constructor: (@editor, @optionsList) ->
    @boxes = []

  execute: ->
    if @optionsList?
      for i in [0..@optionsList-1]
        @boxes[i] = new Box @editor.area.boxesContainer.element, @options if !@boxes[i]?
        @editor.area.boxesContainer.addBox @boxes[i]
        @editor.panel.addBoxRow @boxes[i].element.attr('id')
    else
      @boxes.push new Box @editor.area.boxesContainer.element if @boxes.length == 0
      @editor.area.boxesContainer.addBox @boxes[0]
      @editor.panel.addBoxRow @boxes[0].element.attr('id')

  undo: ->
    for box in @boxes
      @editor.area.boxesContainer.removeBoxes [box.element.attr('id')]
      @editor.panel.removeBoxRow [box.element.attr('id')]