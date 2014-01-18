#= require KeyCodes

###
Keyboard Mapping Controller for clients running on Mac
###
class MacController

  constructor: (@root) ->
    @leftCmdKeyPressed = false
    @rightCmdKeyPressed = false

  bindEvents: ->
    @root
      .keydown (event) =>

        if event.keyCode == KeyCodes.MAC_CMD_LEFT
          @leftCmdKeyPressed = true

        else if event.keyCode == KeyCodes.Z && @_cmdKeyIsPressed()
          event.preventDefault()
          @root.trigger 'requestUndo'

        else if event.keyCode == KeyCodes.Y && @_cmdKeyIsPressed()
          event.preventDefault()
          @root.trigger 'requestRedo'

        else if event.keyCode == KeyCodes.MAC_DELETE && @_cmdKeyIsPressed()
          event.preventDefault()
          @root.trigger 'requestDelete'

        else if event.keyCode == KeyCodes.C &&
                  @_cmdKeyIsPressed() &&
                  event.shiftKey
          event.preventDefault()
          @root.trigger 'requestCopy'

        else if event.keyCode == KeyCodes.V &&
                  @_cmdKeyIsPressed() &&
                  event.shiftKey
          event.preventDefault()
          @root.trigger 'requestPaste'

      .keyup (event) =>
        if event.keyCode == KeyCodes.MAC_CMD_LEFT
          @leftCmdKeyPressed = false

        if event.keyCode == KeyCodes.MAC_CMD_RIGHT
          @rightCmdKeyPressed = false

        if event.keyCode == KeyCodes.SHIFT
          @shiftKeyPressed = false

  _cmdKeyIsPressed: ->
    return @rightCmdKeyPressed or @leftCmdKeyPressed