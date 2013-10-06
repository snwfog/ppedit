#= require Box
#= require BoxesContainer

class CreateBoxCommand

  constructor: (@boxesContainer, @options) ->
    @box = undefined

  execute: ->
      @box = new Box @boxesContainer.element, @options if !@box?
      @boxesContainer.addBox @box

  undo: ->
    @boxesContainer.removeBoxes [@box.element.attr('id')]
