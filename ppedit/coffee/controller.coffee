#= require EditorManager

class Controller

  constructor: (@root) ->
    @editorManager = new EditorManager @root

  start: ->
    createBoxbutton = $("<button>Create Box</button>")
    @root.append(createBoxbutton);
    createBoxbutton.click =>
      @editorManager.createBox()
