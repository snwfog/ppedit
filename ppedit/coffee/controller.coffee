#= require EditorManager

class Controller

  constructor: (@root) ->

    editorManager = new EditorManager @root
    @root = @root.addClass("ppedit-container");

    createBoxbutton = $("<button>Create Box</button>")
    @root.append(createBoxbutton);
    createBoxbutton.click ->
      editorManager.createBox()




