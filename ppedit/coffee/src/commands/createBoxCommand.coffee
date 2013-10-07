#= require Box

###
A command that creates a new box with the passed options
ands adds it to the list.
###
class CreateBoxCommand

  constructor: (@editor, @options) ->
    @box = undefined

  execute: ->
    @box = new Box @editor.area.boxesContainer.element, @options if !@box?
    @editor.area.boxesContainer.addBox @box
    @editor.panel.addBoxRow @box.element.attr('id')

  undo: ->
    @editor.area.boxesContainer.removeBoxes [@box.element.attr('id')]
    @editor.panel.removeBoxRow [@box.element.attr('id')]
