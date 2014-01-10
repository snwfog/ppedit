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
    .simulate 'mousedown',
      clientX:previousPosition.left + 1
      clientY:previousPosition.top + 1

    .simulate "mousemove",
      clientX:previousPosition.left + 1
      clientY:previousPosition.top + 1

    .simulate "mousemove",
      clientX:previousPosition.left + 2
      clientY:previousPosition.top + 2

    .simulate "mousemove",
      clientX:previousPosition.left + distance.dx
      clientY:previousPosition.top + distance.dy

    .simulate "mousemove",
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
  simulateBoxDblClick box, ->
    expect(box).toBeFocused()

    box.simulate "key-sequence",
      sequence: text
      callback: ->
        expect(box).toHaveHtml(text)

###
Simulates ctrl/cmd + delete
###
requestDelete = ->
  $('.ppedit-box-container').simulate 'key-combo', {combo: 'ctrl+46'}; # If Windows
  $('.ppedit-box-container').simulate 'key-combo', {combo: 'meta+8'}; # If Mac

###
Simulates click on a box

  @param selector the selector matching a set of boxes
  @param callback the callback to be called after the click is performed
###
simulateBoxClick = (selector, callback) ->
  selector.simulate 'mousedown'
  selector.simulate 'mouseup'
  setTimeout (=> callback()), 300

###
Simulates doubleclick on a box

  @param selector the selector matching a set of boxes
  @param callback the callback to be called after the doubleclick is performed
###
simulateBoxDblClick = (selector, callback) ->
  selector.simulate 'mousedown'
  selector.simulate 'mouseup'
  selector.simulate 'mousedown'
  selector.simulate 'mouseup'
  setTimeout (=> callback()), 300
