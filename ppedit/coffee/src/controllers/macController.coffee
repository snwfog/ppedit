class MacController

  @COMMAND_LEFT_KEY_CODE: 91 # only on WebKit
  @COMMAND_RIGHT_KEY_CODE: 93 # only on WebKit

  @Z_KEY_CODE: 90
  @Y_KEY_CODE: 89
  @DELETE_KEY_CODE: 8

  constructor: (@root) ->
    @leftCmdKeyPressed = false
    @rightCmdKeyPressed = false

  bindEvents: ->
    @root
      .keydown (event) =>

        if event.keyCode == MacController.COMMAND_LEFT_KEY_CODE
          @leftCmdKeyPressed = true

        else if event.keyCode == MacController.COMMAND_RIGHT_KEY_CODE
          @rightCmdKeyPressed = true

        else if event.keyCode == MacController.Z_KEY_CODE && @_cmdKeyIsPressed()
          event.preventDefault()
          @root.trigger 'requestUndo'

        else if event.keyCode == MacController.Y_KEY_CODE && @_cmdKeyIsPressed()
          event.preventDefault()
          @root.trigger 'requestRedo'

        else if event.keyCode == MacController.DELETE_KEY_CODE && @_cmdKeyIsPressed()
          event.preventDefault()
          @root.trigger 'requestDelete'

      .keyup (event) =>
        if event.keyCode == MacController.COMMAND_LEFT_KEY_CODE
          @leftCmdKeyPressed = false

        if event.keyCode == MacController.COMMAND_RIGHT_KEY_CODE
          @rightCmdKeyPressed = false

  _cmdKeyIsPressed: ->
    return @rightCmdKeyPressed or @leftCmdKeyPressed