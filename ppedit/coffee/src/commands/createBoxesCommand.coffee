#= require Box
#= require Command

###
A command that creates one or more boxes with the passed options
ands adds it to the list.
###
class CreateBoxesCommand extends Command

  ###
  Creates a command that, when executed, will create
  one or more boxes with a passed array of options, one
  for each box to create and add it to the list of current boxes.
  If no optionsList is passed, only one box is created with the default options.
  ###
  constructor: (@editor, @editContainer, @optionsList) ->
    super()
    @boxes = []

  execute: ->
    if @optionsList?
      if @boxes.length == 0
        if @editContainer == true
          @boxes.push new Box @editor.area1.boxesContainer.element, options for options in @optionsList
        else
          @boxes.push new Box @editor.area2.boxesContainer.element, options for options in @optionsList
      @_addBox box for box in @boxes
    else
      if @editContainer == true
        @boxes.push new Box @editor.area1.boxesContainer.element if @boxes.length == 0
      else
        @boxes.push new Box @editor.area2.boxesContainer.element if @boxes.length == 0
      @_addBox @boxes[0]

  undo: ->
    for box in @boxes
      if @editContainer == true
        @editor.area1.boxesContainer.removeBoxes [box.element.attr('id')]
        @editor.panel1.removeBoxRow [box.element.attr('id')]
      else
        @editor.area2.boxesContainer.removeBoxes [box.element.attr('id')]
        @editor.panel2.removeBoxRow [box.element.attr('id')]


  ###
  Adds the passed box to the boxcontainer and
  create a corresponding row in the panel
  ###
  _addBox: (box) ->
    if @editContainer == true
      @editor.area1.boxesContainer.addBox box
    else
      @editor.area2.boxesContainer.addBox box
    boxId = box.element.attr('id')
    if @editContainer == true
      @editor.panel1.addBoxRow boxId
    else
      @editor.panel2.addBoxRow boxId
    @boxIds.push boxId if @boxIds.indexOf(boxId) == -1

  getType: ->
    return 'Create'
