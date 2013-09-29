#= require Controller
#= require EditorManager

class PCController extends Controller
  
  constructor: (@root) ->
    super @root
    @editorManager.root.keydown (event) =>
      if event.keyCode == 90 && event.ctrlKey
        @editorManager.undo()
    @editorManager.root.  keydown (event) =>
      if event.keyCode == 89 && event.ctrlKey
        @editorManager.redo()
    @editorManager.root.keydown (event) =>
      if event.keyCode == 46 || (event.keyCode == 46 && event.ctrlKey)
        @editorManager.deleteOnFocus()
