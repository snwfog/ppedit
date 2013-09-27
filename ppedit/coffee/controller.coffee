#= require EditorManager

class Controller

  constructor: (@root) ->
    @editorManager = new EditorManager @root

  start: ->
    createBoxbutton = $("<button>Create Box</button>")
    createRemovebutton = $("<button>Remove Box</button>")
    @root.append(createBoxbutton);
    @root.append(createRemovebutton);
    createBoxbutton.click =>
      @editorManager.createBox()
    createRemovebutton.click =>
      @editorManager.removeBox()


