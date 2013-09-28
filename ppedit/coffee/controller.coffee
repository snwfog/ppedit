#= require EditorManager

class Controller

  constructor: (@root) ->
    @editorManager = new EditorManager @root

  start: ->
    createBoxbutton = $("<button>Create Box</button>")
    createRemovebutton = $("<button>Remove Box</button>")
    $('body').append(createBoxbutton);
    $('body').append(createRemovebutton);
    createBoxbutton.click =>
      @editorManager.createBox()
    createRemovebutton.click =>
      @editorManager.removeBox()


