#= require KeyCodes

class PCController
  
  constructor: (@root) ->

  bindEvents: ->
    @root.keydown (event) =>
      if event.keyCode == KeyCodes.Z && event.ctrlKey
        event.preventDefault()
        @root.trigger 'requestUndo'

      if event.keyCode == KeyCodes.Y && event.ctrlKey
        event.preventDefault()
        @root.trigger 'requestRedo'

      if event.keyCode == KeyCodes.DELETE || (event.keyCode == KeyCodes.DELETE && event.ctrlKey)
        event.preventDefault()
        @root.trigger 'requestDelete'

      if event.keyCode == KeyCodes.C && event.ctrlKey
        event.preventDefault()
        @root.trigger 'requestCopy'

      if event.keyCode == KeyCodes.C && event.ctrlKey
        event.preventDefault()
        @root.trigger 'requestPaste'
