#= require PCController

class ControllerFactory

  @getController: (root) ->
    return new PCController root