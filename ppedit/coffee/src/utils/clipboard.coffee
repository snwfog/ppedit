###
Helper class used to temporarily save DOM nodes.
###
class Clipboard

  constructor: ->
    @items = undefined

  ###
  Saves the passed newItems jQuery selector
  ###
  pushItems: (newItems) ->
    @items = newItems.clone()

  ###
  Returns the saved jQuery selector and removes it from the save.
  ###
  popItems: ->
    results = @items
    @items = undefined
    return if results? then results else []
