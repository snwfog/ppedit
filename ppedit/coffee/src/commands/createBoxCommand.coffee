#= require Box

###
A command that creates a new box with the passed options
ands adds it to the list.
###
class CreateBoxCommand

  constructor: (@editor, @options) ->
    @box = undefined

  execute: ->
    @box = new Box @editor.editorManager.boxesContainer.element, @options if !@box?
    @editor.editorManager.boxesContainer.addBox @box
    @editor.panel.addElement "dataPanel", @box.element.attr('id')

  undo: ->
    @editor.editorManager.boxesContainer.removeBoxes [@box.element.attr('id')]
    @editor.panel.element.find('tr[ppedit-box-id=' + (@box.element.attr "id") + ']').remove()
