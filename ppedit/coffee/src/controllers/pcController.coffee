class PCController
  
  constructor: (@root) ->

  bindEvents: ->

    @root.keydown (event) =>
      if event.keyCode == 90 && event.ctrlKey
        event.preventDefault()
        @root.trigger 'requestUndo'

      if event.keyCode == 89 && event.ctrlKey
        event.preventDefault()
        @root.trigger 'requestRedo'

      if event.keyCode == 46 || (event.keyCode == 46 && event.ctrlKey)
        event.preventDefault()
        @root.trigger 'requestDelete'
