#= require Box

###
A command that creates one or more boxes with the passed options
ands adds it to the list.
###
class CreateBoxesCommand

  ###
  Creates a command that, when executed, will create
  one or more boxes with a passed array of options, one
  for each box to create and add it to the list of current boxes.
  If no optionsList is passed, only one box is created with the default options.
  ###
  constructor: (@editor, @optionsList) ->
    @boxes = []

  execute: ->
    console.log @optionsList
    if @optionsList?
      if @boxes.length == 0
        @boxes.push new Box @editor.area.boxesContainer.element, options for options in @optionsList
      @_addBox box for box in @boxes
    else
      @boxes.push new Box @editor.area.boxesContainer.element if @boxes.length == 0
      @_addBox @boxes[0]

  undo: ->
    for box in @boxes
      @editor.area.boxesContainer.removeBoxes [box.element.attr('id')]
      @editor.panel.removeBoxRow [box.element.attr('id')]

  ###
  Adds the passed box to the boxcontainer and
  create a corresponding row in the panel
  ###
  _addBox: (box) ->
    @editor.area.boxesContainer.addBox box
    @editor.panel.addBoxRow box.element.attr('id')
