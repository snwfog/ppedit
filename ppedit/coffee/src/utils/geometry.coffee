class Geometry

  ###
  Returns true if the innerRect Rectangle is fully
  contained within the outerRect Rectangle, false otherwise.
  ###
  @rectContainsRect: (outerRect, innerRect) ->
    return (innerRect.topLeft.left >= outerRect.topLeft.left &&
    innerRect.topLeft.top >= outerRect.topLeft.top &&
    innerRect.topLeft.left + innerRect.size.width <= outerRect.topLeft.left + outerRect.size.width &&
    innerRect.topLeft.top + innerRect.size.height <= outerRect.topLeft.top + outerRect.size.height)

  ###
  Returns true if the passed point is contained
   within the passed rectangle, false otherwise.
  ###
  @rectContainsPoint: (rect, point) ->
    return (point.left >= rect.topLeft.left &&
    point.top >= rect.topLeft.top &&
    point.left <= rect.topLeft.left + rect.size.width &&
    point.top <= rect.topLeft.top + rect.size.height)

  ###
  Returns true if the passed points have the
  same coordinate, false otherwise.
  ###
  @pointEqualToPoint: (point1, point2) ->
    return point1.left == point2.left and point1.top == point2.top