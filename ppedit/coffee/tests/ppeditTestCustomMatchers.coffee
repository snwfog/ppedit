ppeditMatchers =

  ###
  Returns True if the expected position equals
  the passed position
  ###
  toBeEqualToPosition: (expected) ->
    return Math.round(expected.top) == Math.round(@actual.top) and
            Math.round(expected.left) == Math.round(@actual.left)
