###
Abstract Class, represents an Dom node
###
class Graphic

  ###
  Create a new graphic using the passed jQuery selector matching
  the element this dom node will be appended to.
  ###
  constructor: (@root) ->
    @element = undefined

  ###
  Creates the element node and append it
  to the passed root
  ###
  buildElement: ->

  ###
  Method called after the element has been appended
  to the DOM.
  ###
  bindEvents: ->