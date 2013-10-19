class Clipboard

  constructor: ->
    @items = undefined

  saveItemsStyle: (newItems) ->
    @items = newItems.clone()