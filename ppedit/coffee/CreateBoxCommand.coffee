#= require ICommand
#= require Box

class CreateBoxCommand extends ICommand

  constructor: (@root, @options) ->
    super @root
    @box = undefined

  execute: ->
    @box = new Box @root, @options if !@box?
    @root.append @box.element

  undo: ->
    @box.element.remove()
