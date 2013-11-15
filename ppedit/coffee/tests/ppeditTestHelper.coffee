#= require <ppeditTestCustomMatchers.coffee>

###
Returns the position of the first element in the set of matched
elements relative to the browser viewport.
###
viewPortPosition = (jQuerySelector) ->
  left: jQuerySelector.offset().left + jQuerySelector.scrollLeft()
  top: jQuerySelector.offset().top + jQuerySelector.scrollTop()

###
Adds a given number of boxes on an EMPTY box container
###
addBox = (numOfBoxes)->
  $(".addElementBtn").click() for i in [0..numOfBoxes-1]
  expect($('.ppedit-box')).toHaveLength(numOfBoxes)

###
Simulates moving the passed box
by the specified distance amount
###
moveBox = (boxSelector, distance) ->

  previousPosition = viewPortPosition boxSelector

  boxSelector
    .simulate 'click',
      clientX:previousPosition.left + 1
      clientY:previousPosition.top + 1

    .simulate "mousemove",
      clientX:previousPosition.left + 1
      clientY:previousPosition.top + 1

    .simulate "mousemove",
      clientX:previousPosition.left + 1 + distance.dx
      clientY:previousPosition.top + 1 + distance.dy

    .simulate 'click',
      clientX:previousPosition.left + 1 + distance.dx
      clientY:previousPosition.top + 1 + distance.dy

    .simulate 'mouseup',
        clientX:previousPosition.left + 1 + distance.dx
        clientY:previousPosition.top + 1 + distance.dy

  expect(viewPortPosition boxSelector).toBeEqualToPosition
    left:previousPosition.left + distance.dx
    top:previousPosition.top + distance.dy

###
Simulates a rectangular selection on the passed
canvas with the parameter specified by the passed rect
###
selectRectangle = (canvasSelector, rect) ->

  canvasSelector
    .simulate "mousedown",
      clientX:rect.topLeft.left
      clientY:rect.topLeft.top

    .simulate "mousemove",
      clientX:rect.topLeft.left
      clientY:rect.topLeft.top

    .simulate "mousemove",
      clientX:rect.topLeft.left + rect.size.width
      clientY:rect.topLeft.top + rect.size.height

    .simulate "mouseup",
      clientX:rect.topLeft.left + rect.size.width
      clientY:rect.topLeft.top + rect.size.height

###
Simulates entering the specified text into the passed box
###
enterText = (box, text) ->
  box.simulate 'dblclick'
  expect(box).toBeFocused()

  box.simulate "key-sequence",
    sequence: text
    callback: ->
      expect(box).toHaveHtml(text)
