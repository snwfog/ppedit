#= require EditorManager

class Controller

  constructor: (@root) ->

    @editorManager = new EditorManager @root
    @root = this.addClass("ppedit-container");

    createBoxbutton = $("<button>Create Box</button>")
    this.append(createBoxbutton);
    createBoxbutton.click ->
      @editorManager.createBox()




