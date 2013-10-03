#= require ICommand
#= require Box
#= require BoxesContainer

class CreateBoxCommand extends ICommand

  constructor: (@root, @boxesContainer, @options) ->
    super @root
    @box = undefined

  execute: ->
    if !@box?
      @box = @boxesContainer.createBox(@options) 
    else
      @boxesContainer.addBox @box

  undo: ->
    @boxesContainer.removeBoxes [@box.element.attr('id')]
