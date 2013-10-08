#= require PCController
#= require MacController

###
the ControllerFactory determines which controller
to used based on the user's Operating System.
###
class ControllerFactory

  @getController: (root) ->
    if navigator.userAgent.match(/Macintosh/) is not null
      return new MacController root
    else
      return new PCController root