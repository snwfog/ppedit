ppeditMatchers =

  ###
  Returns True if the expected position equals
  the passed position
  ###
  toBeEqualToPosition: (expected) ->
    return expected.top == @actual.top and expected.left == @actual.left
