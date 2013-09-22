#= require EditorManager

class Controller

  constructor: (@root) ->

    @root.addClass("ppedit-container");
    @editorManager = new EditorManager @root

    createBoxbutton = $("<button>Create Box</button>")
    @root.append(createBoxbutton);
    createBoxbutton.click =>
      @editorManager.createBox()




