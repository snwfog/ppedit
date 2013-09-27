#= require ICommand
#= require Box

class CreateBoxCommand extends ICommand

  constructor: (@root, @options) ->
    super @root
    @box = null

  execute: ->
    @box = new Box @root, @options
    @root.append @box.element

  undo: ->
    # @root.remove @box.element
    @box.element.remove()
