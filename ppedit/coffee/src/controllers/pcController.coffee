class PCController
  
  constructor: (@element) ->

  bindEvents: ->

    @element.keydown (event) =>
      if event.keyCode == 90 && event.ctrlKey
        event.preventDefault()
        @element.trigger 'requestUndo'

      if event.keyCode == 89 && event.ctrlKey
        event.preventDefault()
        @element.trigger 'requestRedo'

      if event.keyCode == 46 || (event.keyCode == 46 && event.ctrlKey)
        event.preventDefault()
        @element.trigger 'requestDelete'
