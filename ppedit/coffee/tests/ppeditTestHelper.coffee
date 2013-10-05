#= require <ppeditTestCustomMatchers.coffee>

###
Simulates moving the passed box
by the specified distance amount
###
moveBox = (boxSelector, distance) ->

  previousPosition =
    left: boxSelector.offset().left + boxSelector.scrollLeft()
    top: boxSelector.offset().top + boxSelector.scrollTop()

  boxSelector
    .simulate "mousedown",
      clientX:previousPosition.left + 1
      clientY:previousPosition.top + 1

    .simulate "mousemove",
      clientX:previousPosition.left + 1
      clientY:previousPosition.top + 1

    .simulate "mousemove",
      clientX:previousPosition.left + 1 + distance.dx
      clientY:previousPosition.top + 1 + distance.dy

    .simulate "mouseup",
      clientX:previousPosition.left + distance.dx
      clientY:previousPosition.top + distance.dy

  expect(boxSelector.offset()).toBeEqualToPosition
    left:previousPosition.left + distance.dx
    top:previousPosition.top + distance.dy
