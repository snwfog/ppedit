class BoxesContainer
  constructor: (@root) ->
    @element = $('<div></div>').addClass('ppedit-box-container')
    @root.append(@element)