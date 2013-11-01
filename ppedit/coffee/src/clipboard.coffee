class Clipboard

  constructor: ->
    @items = undefined

  pushItems: (newItems) ->
    @items = newItems.clone()

  popItems: ->
    results = @items
    @items = undefined
    return if results? then results else []
