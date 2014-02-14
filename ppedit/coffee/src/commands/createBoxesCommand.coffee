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
  constructor: (@editor, @pageNum, @optionsList) ->
    super()
    @boxes = []

  execute: ->
    if @optionsList?
      if @boxes.length == 0
        @boxes.push new Box @editor.areas[@pageNum].boxesContainer.element, options for options in @optionsList
      @_addBox box for box in @boxes
    else
      @boxes.push new Box @editor.areas[@pageNum].boxesContainer.element if @boxes.length == 0
      @_addBox @boxes[0]

  undo: ->
    for box in @boxes
      @editor.areas[@pageNum].boxesContainer.removeBoxes [box.element.attr('id')]
      @editor.panel.removeBoxRow [box.element.attr('id')]

  ###
  Adds the passed box to the boxcontainer and
  create a corresponding row in the panel
  ###
  _addBox: (box) ->
    @editor.areas[@pageNum].boxesContainer.addBox box
    boxId = box.element.attr('id')
    @editor.panel.addBoxRow @pageNum, boxId
    @boxIds.push boxId if @boxIds.indexOf(boxId) == -1

  getType: ->
    return 'Create'

  getPageNum: ->
    return @pageNum
