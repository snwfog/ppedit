class Clipboard

  constructor: ->
    @itemsStyles = []

  saveItemsStyle: (newItems) ->
    @itemsStyles = []
    newItems.each (index, item) =>
      @itemsStyles.push CSSJSON.toJSON(item.style.cssText).attributes